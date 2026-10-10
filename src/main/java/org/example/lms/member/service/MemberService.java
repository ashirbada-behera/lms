
package org.example.lms.member.service;

import org.example.lms.member.domain.MemberStatus;
import org.example.lms.member.dto.MemberCreateRequest;
import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.dto.MemberUpdateRequest;

import java.util.List;

public interface MemberService {

    MemberResponse createMember(MemberCreateRequest request);

    MemberResponse getMemberById(Long id);

    MemberResponse getMemberByCode(String memberCode);

    MemberResponse updateMember(Long id, MemberUpdateRequest request);

    List<MemberResponse> getAllMembers();

    List<MemberResponse> getMembersByStatus(MemberStatus status);

    List<MemberResponse> searchMembers(String query);

    void deactivateMember(Long id);

    void changeMemberStatus(Long id, MemberStatus status);
}
