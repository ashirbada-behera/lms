
package org.example.lms.member.repository;

import org.example.lms.member.domain.Member;
import org.example.lms.member.domain.MemberStatus;

import java.util.List;
import java.util.Optional;

public interface MemberRepository {

    Member save(Member member);

    Optional<Member> findById(Long id);

    Optional<Member> findByMemberCode(String memberCode);

    Optional<Member> findByEmail(String email);

    List<Member> findAll();

    List<Member> findByStatus(MemberStatus status);

    List<Member> search(String query);

    boolean existsByMemberCode(String memberCode);

    boolean existsByEmail(String email);

    boolean existsByMemberCodeAndIdNot(String memberCode, Long id);

    boolean existsByEmailAndIdNot(String email, Long id);
}
