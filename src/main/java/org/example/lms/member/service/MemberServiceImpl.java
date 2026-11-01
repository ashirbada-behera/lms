
package org.example.lms.member.service;

import org.example.lms.member.domain.Member;
import org.example.lms.member.domain.MemberStatus;
import org.example.lms.member.domain.MembershipType;
import org.example.lms.member.dto.MemberCreateRequest;
import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.dto.MemberUpdateRequest;
import org.example.lms.member.repository.MemberRepository;
import org.example.lms.member.repository.MemberRepositoryImpl;

import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.UUID;

public class MemberServiceImpl implements MemberService {

    private final MemberRepository memberRepository;

    // ==========================================
    // CONSTRUCTORS
    // ==========================================

    public MemberServiceImpl() {
        this(new MemberRepositoryImpl());
    }

    public MemberServiceImpl(MemberRepository memberRepository) {
        this.memberRepository = Objects.requireNonNull(
                memberRepository,
                "MemberRepository is required."
        );
    }

    // ==========================================
    // CREATE MEMBER
    // ==========================================

    @Override
    public MemberResponse createMember(MemberCreateRequest request) {

        Objects.requireNonNull(
                request,
                "Member creation request is required."
        );

        String fullName = requireText(
                request.getFullName(),
                "Full name"
        );

        validateFullName(fullName);

        String email = normalizeEmail(request.getEmail());

        String phone = requireText(
                request.getPhone(),
                "Phone"
        );

        MembershipType membershipType =
                requireMembershipType(request.getMembershipType());

        LocalDate today = LocalDate.now();

        validateEmail(email);
        validatePhone(phone);
        validateDateOfBirth(request.getDateOfBirth());

        String address = normalizeOptionalText(request.getAddress());

        if (memberRepository.existsByEmail(email)) {
            throw new IllegalArgumentException(
                    "A member with this email address already exists."
            );
        }

        // Correct 11-argument constructor.
        Member member = new Member(
                generateMemberCode(),
                fullName,
                email,
                phone,
                request.getDateOfBirth(),
                request.getGender(),
                address,
                membershipType,
                today,
                today.plusYears(1),
                MemberStatus.ACTIVE
        );

        return toResponse(memberRepository.save(member));
    }

    // ==========================================
    // GET MEMBER BY ID
    // ==========================================

    @Override
    public MemberResponse getMemberById(Long id) {
        return toResponse(findRequiredMember(id));
    }

    // ==========================================
    // GET MEMBER BY CODE
    // ==========================================

    @Override
    public MemberResponse getMemberByCode(String memberCode) {

        String code = requireText(memberCode, "Member code");

        Member member = memberRepository.findByMemberCode(code)
                .orElseThrow(() -> new MemberNotFoundException(
                        "No member found with code: " + code
                ));

        return toResponse(member);
    }

    // ==========================================
    // UPDATE MEMBER
    // ==========================================

    @Override
    public MemberResponse updateMember(
            Long id,
            MemberUpdateRequest request
    ) {

        Objects.requireNonNull(
                request,
                "Member update request is required."
        );

        Member member = findRequiredMember(id);

        String fullName = requireText(
                request.getFullName(),
                "Full name"
        );

        validateFullName(fullName);

        String email = normalizeEmail(request.getEmail());

        String phone = requireText(
                request.getPhone(),
                "Phone"
        );

        MembershipType membershipType =
                requireMembershipType(request.getMembershipType());

        validateEmail(email);
        validatePhone(phone);
        validateDateOfBirth(request.getDateOfBirth());

        String address = normalizeOptionalText(request.getAddress());

        if (memberRepository.existsByEmailAndIdNot(email, id)) {
            throw new IllegalArgumentException(
                    "Another member already uses this email address."
            );
        }

        LocalDate registrationDate = Objects.requireNonNull(
                request.getRegistrationDate(),
                "Registration date is required."
        );

        LocalDate validUntil = Objects.requireNonNull(
                request.getValidUntil(),
                "Membership expiry date is required."
        );

        validateMembershipPeriod(registrationDate, validUntil);

        // Update existing member fields.
        member.setFullName(fullName);
        member.setEmail(email);
        member.setPhone(phone);
        member.setDateOfBirth(request.getDateOfBirth());
        member.setGender(request.getGender());
        member.setAddress(address);
        member.setMembershipType(membershipType);
        member.setRegistrationDate(registrationDate);
        member.setValidUntil(validUntil);

        return toResponse(memberRepository.save(member));
    }

    // ==========================================
    // GET ALL MEMBERS
    // ==========================================

    @Override
    public List<MemberResponse> getAllMembers() {

        return memberRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    // ==========================================
    // GET MEMBERS BY STATUS
    // ==========================================

    @Override
    public List<MemberResponse> getMembersByStatus(
            MemberStatus status
    ) {

        Objects.requireNonNull(
                status,
                "Member status is required."
        );

        return memberRepository.findByStatus(status)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    // ==========================================
    // SEARCH MEMBERS
    // ==========================================

    @Override
    public List<MemberResponse> searchMembers(String query) {

        if (query == null || query.isBlank()) {
            return getAllMembers();
        }

        return memberRepository.search(query.trim())
                .stream()
                .map(this::toResponse)
                .toList();
    }

    // ==========================================
    // SEARCH MEMBERS WITH STATUS FILTER
    // ==========================================

    @Override
    public List<MemberResponse> searchMembers(
            String query,
            MemberStatus status
    ) {

        return memberRepository.searchByQueryAndStatus(
                        query,
                        status
                )
                .stream()
                .map(this::toResponse)
                .toList();
    }

    // ==========================================
    // DEACTIVATE MEMBER
    // ==========================================

    @Override
    public void deactivateMember(Long id) {

        Member member = findRequiredMember(id);

        if (member.getStatus() != MemberStatus.INACTIVE) {

            member.setStatus(MemberStatus.INACTIVE);

            memberRepository.save(member);
        }
    }

    // ==========================================
    // CHANGE MEMBER STATUS
    // ==========================================

    @Override
    public void changeMemberStatus(
            Long id,
            MemberStatus status
    ) {

        Member member = findRequiredMember(id);

        Objects.requireNonNull(
                status,
                "Member status is required."
        );

        member.setStatus(status);

        memberRepository.save(member);
    }

    // ==========================================
    // FIND REQUIRED MEMBER
    // ==========================================

    private Member findRequiredMember(Long id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Member ID must be a positive number."
            );
        }

        return memberRepository.findById(id)
                .orElseThrow(() -> new MemberNotFoundException(
                        "No member found with ID: " + id
                ));
    }

    // ==========================================
    // CONVERT MEMBER TO RESPONSE DTO
    // ==========================================

    private MemberResponse toResponse(Member member) {

        MemberResponse response = new MemberResponse();

        response.setId(member.getId());
        response.setMemberCode(member.getMemberCode());
        response.setFullName(member.getFullName());
        response.setEmail(member.getEmail());
        response.setPhone(member.getPhone());
        response.setDateOfBirth(member.getDateOfBirth());
        response.setGender(member.getGender());
        response.setAddress(member.getAddress());
        response.setMembershipType(member.getMembershipType());
        response.setRegistrationDate(member.getRegistrationDate());
        response.setValidUntil(member.getValidUntil());
        response.setStatus(member.getStatus());
        response.setCreatedAt(member.getCreatedAt());
        response.setUpdatedAt(member.getUpdatedAt());

        return response;
    }

    // ==========================================
    // GENERATE UNIQUE MEMBER CODE
    // ==========================================

    private String generateMemberCode() {

        return "MEM-" + UUID.randomUUID()
                .toString()
                .replace("-", "")
                .substring(0, 12)
                .toUpperCase(Locale.ROOT);
    }

    // ==========================================
    // REQUIRED TEXT VALIDATION
    // ==========================================

    private static String requireText(
            String value,
            String field
    ) {

        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(
                    field + " is required."
            );
        }

        return value.trim();
    }

    // ==========================================
    // FULL NAME VALIDATION
    // ==========================================

    private static void validateFullName(String fullName) {

        if (fullName.length() > 120) {
            throw new IllegalArgumentException(
                    "Full name must not exceed 120 characters."
            );
        }
    }

    // ==========================================
    // EMAIL VALIDATION
    // ==========================================

    private static String normalizeEmail(String email) {

        return requireText(
                email,
                "Email"
        ).toLowerCase(Locale.ROOT);
    }

    private static void validateEmail(String email) {

        String emailPattern =
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";

        if (email.length() > 150 || !email.matches(emailPattern)) {
            throw new IllegalArgumentException(
                    "Please provide a valid email address."
            );
        }
    }

    // ==========================================
    // PHONE VALIDATION
    // ==========================================

    private static void validatePhone(String phone) {

        String phonePattern = "^[0-9+()\\-\\s]{7,20}$";

        if (phone.length() > 20 || !phone.matches(phonePattern)) {
            throw new IllegalArgumentException(
                    "Please provide a valid phone number."
            );
        }
    }

    // ==========================================
    // DATE OF BIRTH VALIDATION
    // ==========================================

    private static void validateDateOfBirth(
            LocalDate dateOfBirth
    ) {

        if (dateOfBirth != null
                && !dateOfBirth.isBefore(LocalDate.now())) {

            throw new IllegalArgumentException(
                    "Date of birth must be in the past."
            );
        }
    }

    // ==========================================
    // MEMBERSHIP PERIOD VALIDATION
    // ==========================================

    private static void validateMembershipPeriod(
            LocalDate registrationDate,
            LocalDate validUntil
    ) {

        if (validUntil.isBefore(registrationDate)) {
            throw new IllegalArgumentException(
                    "Membership expiry date cannot precede registration date."
            );
        }
    }

    // ==========================================
    // OPTIONAL ADDRESS NORMALIZATION
    // ==========================================

    private static String normalizeOptionalText(String value) {

        if (value == null || value.isBlank()) {
            return null;
        }

        String normalized = value.trim();

        if (normalized.length() > 500) {
            throw new IllegalArgumentException(
                    "Address must not exceed 500 characters."
            );
        }

        return normalized;
    }

    // ==========================================
    // MEMBERSHIP TYPE VALIDATION
    // ==========================================

    private static MembershipType requireMembershipType(
            MembershipType membershipType
    ) {

        if (membershipType == null) {
            throw new IllegalArgumentException(
                    "Membership type is required."
            );
        }

        return membershipType;
    }
}
