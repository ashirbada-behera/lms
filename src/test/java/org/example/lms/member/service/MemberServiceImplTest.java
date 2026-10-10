package org.example.lms.member.service;

import org.example.lms.member.domain.Gender;
import org.example.lms.member.domain.Member;
import org.example.lms.member.domain.MemberStatus;
import org.example.lms.member.domain.MembershipType;
import org.example.lms.member.dto.MemberCreateRequest;
import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.dto.MemberUpdateRequest;
import org.example.lms.member.repository.MemberRepository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Field;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class MemberServiceImplTest {

    private MemberRepository memberRepository;
    private MemberServiceImpl memberService;

    @BeforeEach
    void setUp() {
        memberRepository = mock(MemberRepository.class);
        memberService = new MemberServiceImpl(memberRepository);

        when(memberRepository.save(any(Member.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
    }

    private MemberCreateRequest validCreateRequest() {
        MemberCreateRequest request = new MemberCreateRequest();
        request.setFullName("Test Member");
        request.setEmail("TEST@example.com");
        request.setPhone("9876543210");
        request.setMembershipType(MembershipType.STUDENT);
        request.setDateOfBirth(LocalDate.of(2000, 1, 1));
        request.setGender(Gender.MALE);
        request.setAddress("Bhubaneswar");
        return request;
    }

    private Member existingMember(Long id) {
        LocalDate today = LocalDate.now();

        Member member = new Member(
                "MEM-TEST" + String.format("%06d", id),
                "Existing Member",
                "existing" + id + "@example.com",
                "9876543210",
                MembershipType.STUDENT,
                today,
                today.plusYears(1)
        );

        try {
            Field idField = Member.class.getDeclaredField("id");
            idField.setAccessible(true);
            idField.set(member, id);
        } catch (ReflectiveOperationException exception) {
            throw new AssertionError(
                    "Unable to assign the generated ID in the test fixture.",
                    exception
            );
        }

        member.setStatus(MemberStatus.ACTIVE);
        return member;
    }

    private MemberUpdateRequest validUpdateRequest() {
        MemberUpdateRequest request = new MemberUpdateRequest();
        request.setFullName("Updated Member");
        request.setEmail("updated@example.com");
        request.setPhone("9876543211");
        request.setMembershipType(MembershipType.FACULTY);
        request.setDateOfBirth(LocalDate.of(1999, 5, 10));
        request.setGender(Gender.OTHER);
        request.setAddress("Cuttack");
        request.setRegistrationDate(LocalDate.now());
        request.setValidUntil(LocalDate.now().plusYears(1));
        return request;
    }

    @Test
    @DisplayName("Creates a member and normalizes email")
    void createMemberSuccessfully() {
        when(memberRepository.existsByEmail("test@example.com"))
                .thenReturn(false);

        MemberResponse response =
                memberService.createMember(validCreateRequest());

        assertNotNull(response);
        assertEquals("Test Member", response.getFullName());
        assertEquals("test@example.com", response.getEmail());
        assertEquals("9876543210", response.getPhone());
        assertEquals(MembershipType.STUDENT, response.getMembershipType());
        assertEquals(MemberStatus.ACTIVE, response.getStatus());
        assertNotNull(response.getMemberCode());
        assertTrue(response.getMemberCode().startsWith("MEM-"));

        verify(memberRepository).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects a duplicate email during registration")
    void createMemberRejectsDuplicateEmail() {
        when(memberRepository.existsByEmail("test@example.com"))
                .thenReturn(true);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> memberService.createMember(validCreateRequest())
        );

        assertTrue(exception.getMessage().contains("already exists"));
        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects an invalid email")
    void createMemberRejectsInvalidEmail() {
        MemberCreateRequest request = validCreateRequest();
        request.setEmail("invalid-email");

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.createMember(request)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects an invalid phone number")
    void createMemberRejectsInvalidPhone() {
        MemberCreateRequest request = validCreateRequest();
        request.setPhone("12");

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.createMember(request)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects a date of birth that is today or in the future")
    void createMemberRejectsInvalidDateOfBirth() {
        MemberCreateRequest request = validCreateRequest();
        request.setDateOfBirth(LocalDate.now());

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.createMember(request)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects a missing membership type")
    void createMemberRejectsMissingMembershipType() {
        MemberCreateRequest request = validCreateRequest();
        request.setMembershipType(null);

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.createMember(request)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects an address longer than 500 characters")
    void createMemberRejectsLongAddress() {
        MemberCreateRequest request = validCreateRequest();
        request.setAddress("A".repeat(501));

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.createMember(request)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects an empty full name")
    void createMemberRejectsMissingFullName() {
        MemberCreateRequest request = validCreateRequest();
        request.setFullName("  ");

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.createMember(request)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects a null creation request")
    void createMemberRejectsNullRequest() {
        assertThrows(
                NullPointerException.class,
                () -> memberService.createMember(null)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Returns a member when the ID exists")
    void getMemberByIdSuccessfully() {
        Member member = existingMember(1L);
        when(memberRepository.findById(1L))
                .thenReturn(Optional.of(member));

        MemberResponse response = memberService.getMemberById(1L);

        assertEquals(1L, response.getId());
        assertEquals("Existing Member", response.getFullName());
        assertEquals("existing1@example.com", response.getEmail());
    }

    @Test
    @DisplayName("Rejects a non-positive member ID")
    void getMemberByIdRejectsInvalidId() {
        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.getMemberById(0L)
        );

        verify(memberRepository, never()).findById(any());
    }

    @Test
    @DisplayName("Throws when a member ID does not exist")
    void getMemberByIdThrowsWhenMissing() {
        when(memberRepository.findById(99L))
                .thenReturn(Optional.empty());

        assertThrows(
                MemberNotFoundException.class,
                () -> memberService.getMemberById(99L)
        );
    }

    @Test
    @DisplayName("Updates an existing member")
    void updateMemberSuccessfully() {
        Member member = existingMember(1L);

        when(memberRepository.findById(1L))
                .thenReturn(Optional.of(member));
        when(memberRepository.existsByEmailAndIdNot(
                "updated@example.com", 1L
        )).thenReturn(false);

        MemberResponse response = memberService.updateMember(
                1L, validUpdateRequest()
        );

        assertEquals("Updated Member", response.getFullName());
        assertEquals("updated@example.com", response.getEmail());
        assertEquals(MembershipType.FACULTY, response.getMembershipType());

        verify(memberRepository).save(member);
    }

    @Test
    @DisplayName("Rejects an email used by another member")
    void updateMemberRejectsDuplicateEmail() {
        Member member = existingMember(1L);

        when(memberRepository.findById(1L))
                .thenReturn(Optional.of(member));
        when(memberRepository.existsByEmailAndIdNot(
                "updated@example.com", 1L
        )).thenReturn(true);

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.updateMember(
                        1L, validUpdateRequest()
                )
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Rejects an expiry date before registration")
    void updateMemberRejectsInvalidMembershipPeriod() {
        Member member = existingMember(1L);
        MemberUpdateRequest request = validUpdateRequest();
        request.setRegistrationDate(LocalDate.of(2026, 1, 2));
        request.setValidUntil(LocalDate.of(2026, 1, 1));

        when(memberRepository.findById(1L))
                .thenReturn(Optional.of(member));
        when(memberRepository.existsByEmailAndIdNot(
                "updated@example.com", 1L
        )).thenReturn(false);

        assertThrows(
                IllegalArgumentException.class,
                () -> memberService.updateMember(1L, request)
        );

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Deactivates a member without deleting the record")
    void deactivateMemberSuccessfully() {
        Member member = existingMember(1L);

        when(memberRepository.findById(1L))
                .thenReturn(Optional.of(member));

        memberService.deactivateMember(1L);

        assertEquals(MemberStatus.INACTIVE, member.getStatus());
        verify(memberRepository).save(member);
    }

    @Test
    @DisplayName("Does not save a member who is already inactive")
    void deactivateAlreadyInactiveMemberDoesNotSaveAgain() {
        Member member = existingMember(1L);
        member.setStatus(MemberStatus.INACTIVE);

        when(memberRepository.findById(1L))
                .thenReturn(Optional.of(member));

        memberService.deactivateMember(1L);

        verify(memberRepository, never()).save(any(Member.class));
    }

    @Test
    @DisplayName("Returns all members")
    void getAllMembersSuccessfully() {
        Member first = existingMember(1L);
        Member second = existingMember(2L);

        when(memberRepository.findAll())
                .thenReturn(List.of(first, second));

        List<MemberResponse> responses = memberService.getAllMembers();

        assertEquals(2, responses.size());
        verify(memberRepository).findAll();
    }

    @Test
    @DisplayName("Returns all members for a blank search")
    void blankSearchReturnsAllMembers() {
        when(memberRepository.findAll()).thenReturn(List.of());

        List<MemberResponse> responses = memberService.searchMembers(" ");

        assertTrue(responses.isEmpty());
        verify(memberRepository).findAll();
        verify(memberRepository, never()).search(anyString());
    }

    @Test
    @DisplayName("Searches using a trimmed query")
    void searchMembersSuccessfully() {
        when(memberRepository.search("Test Member"))
                .thenReturn(List.of(existingMember(1L)));

        List<MemberResponse> responses =
                memberService.searchMembers("  Test Member  ");

        assertEquals(1, responses.size());
        verify(memberRepository).search("Test Member");
    }

    @Test
    @DisplayName("Changes member status")
    void changeMemberStatusSuccessfully() {
        Member member = existingMember(1L);

        when(memberRepository.findById(1L))
                .thenReturn(Optional.of(member));

        memberService.changeMemberStatus(1L, MemberStatus.SUSPENDED);

        assertEquals(MemberStatus.SUSPENDED, member.getStatus());
        verify(memberRepository).save(member);
    }

    @Test
    @DisplayName("Rejects a null member repository")
    void constructorRejectsNullRepository() {
        assertThrows(
                NullPointerException.class,
                () -> new MemberServiceImpl(null)
        );
    }
}
