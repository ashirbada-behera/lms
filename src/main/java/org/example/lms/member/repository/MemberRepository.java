
package org.example.lms.member.repository;

import org.example.lms.member.domain.Member;
import org.example.lms.member.domain.MemberStatus;

import java.util.List;
import java.util.Optional;

public interface MemberRepository {

    // Create or update a member
    Member save(Member member);

    // Retrieve a member by database ID
    Optional<Member> findById(Long id);

    // Retrieve a member by unique member code
    Optional<Member> findByMemberCode(String memberCode);

    // Retrieve a member by email
    Optional<Member> findByEmail(String email);

    // Retrieve all members
    List<Member> findAll();

    // Retrieve members by membership status
    List<Member> findByStatus(MemberStatus status);

    // Search members using a search query
    List<Member> search(String query);

    // Search members using query and status filters
    List<Member> searchByQueryAndStatus(
            String query,
            MemberStatus status
    );

    // Check whether a member code already exists
    boolean existsByMemberCode(String memberCode);

    // Check whether an email already exists
    boolean existsByEmail(String email);

    // Check duplicate member code excluding a specific member
    boolean existsByMemberCodeAndIdNot(
            String memberCode,
            Long id
    );

    // Check duplicate email excluding a specific member
    boolean existsByEmailAndIdNot(
            String email,
            Long id
    );
}
