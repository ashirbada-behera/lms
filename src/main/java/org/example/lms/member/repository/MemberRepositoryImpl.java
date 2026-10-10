
package org.example.lms.member.repository;

import org.example.lms.config.HibernateUtil;
import org.example.lms.member.domain.Member;
import org.example.lms.member.domain.MemberStatus;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.function.Function;

public class MemberRepositoryImpl implements MemberRepository {

    @Override
    public Member save(Member member) {
        if (member == null) {
            throw new IllegalArgumentException("Member cannot be null.");
        }

        return executeInTransaction(session -> {
            Member savedMember;

            if (member.getId() == null) {
                session.persist(member);
                savedMember = member;
            } else {
                savedMember = session.merge(member);
            }

            session.flush();
            session.refresh(savedMember);

            return savedMember;
        });
    }

    @Override
    public Optional<Member> findById(Long id) {
        if (id == null || id <= 0) {
            return Optional.empty();
        }

        return executeRead(session ->
                Optional.ofNullable(session.find(Member.class, id))
        );
    }

    @Override
    public Optional<Member> findByMemberCode(String memberCode) {
        if (isBlank(memberCode)) {
            return Optional.empty();
        }

        return executeRead(session ->
                session.createQuery(
                                "from Member m where m.memberCode = :code",
                                Member.class
                        )
                        .setParameter("code", memberCode.trim())
                        .uniqueResultOptional()
        );
    }

    @Override
    public Optional<Member> findByEmail(String email) {
        if (isBlank(email)) {
            return Optional.empty();
        }

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);

        return executeRead(session ->
                session.createQuery(
                                "from Member m where lower(m.email) = :email",
                                Member.class
                        )
                        .setParameter("email", normalizedEmail)
                        .uniqueResultOptional()
        );
    }

    @Override
    public List<Member> findAll() {
        return executeRead(session ->
                session.createQuery(
                                "from Member m order by m.id desc",
                                Member.class
                        )
                        .getResultList()
        );
    }

    @Override
    public List<Member> findByStatus(MemberStatus status) {
        if (status == null) {
            throw new IllegalArgumentException(
                    "Member status is required."
            );
        }

        return executeRead(session ->
                session.createQuery(
                                """
                                from Member m
                                where m.status = :status
                                order by m.id desc
                                """,
                                Member.class
                        )
                        .setParameter("status", status)
                        .getResultList()
        );
    }

    @Override
    public List<Member> search(String query) {
        if (isBlank(query)) {
            return findAll();
        }

        String normalizedQuery = query.trim().toLowerCase(Locale.ROOT);
        String pattern = "%" + escapeLike(normalizedQuery) + "%";

        return executeRead(session ->
                session.createQuery(
                                """
                                from Member m
                                where lower(m.memberCode) like :pattern escape '!'
                                   or lower(m.fullName) like :pattern escape '!'
                                   or lower(m.email) like :pattern escape '!'
                                   or lower(m.phone) like :pattern escape '!'
                                order by m.id desc
                                """,
                                Member.class
                        )
                        .setParameter("pattern", pattern)
                        .getResultList()
        );
    }

    @Override
    public boolean existsByMemberCode(String memberCode) {
        if (isBlank(memberCode)) {
            return false;
        }

        return executeRead(session ->
                session.createQuery(
                                """
                                select count(m.id)
                                from Member m
                                where m.memberCode = :code
                                """,
                                Long.class
                        )
                        .setParameter("code", memberCode.trim())
                        .getSingleResult() > 0
        );
    }

    @Override
    public boolean existsByEmail(String email) {
        if (isBlank(email)) {
            return false;
        }

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);

        return executeRead(session ->
                session.createQuery(
                                """
                                select count(m.id)
                                from Member m
                                where lower(m.email) = :email
                                """,
                                Long.class
                        )
                        .setParameter("email", normalizedEmail)
                        .getSingleResult() > 0
        );
    }

    @Override
    public boolean existsByMemberCodeAndIdNot(
            String memberCode,
            Long id
    ) {
        if (isBlank(memberCode) || id == null) {
            return false;
        }

        return executeRead(session ->
                session.createQuery(
                                """
                                select count(m.id)
                                from Member m
                                where m.memberCode = :code
                                  and m.id <> :id
                                """,
                                Long.class
                        )
                        .setParameter("code", memberCode.trim())
                        .setParameter("id", id)
                        .getSingleResult() > 0
        );
    }

    @Override
    public boolean existsByEmailAndIdNot(String email, Long id) {
        if (isBlank(email) || id == null) {
            return false;
        }

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);

        return executeRead(session ->
                session.createQuery(
                                """
                                select count(m.id)
                                from Member m
                                where lower(m.email) = :email
                                  and m.id <> :id
                                """,
                                Long.class
                        )
                        .setParameter("email", normalizedEmail)
                        .setParameter("id", id)
                        .getSingleResult() > 0
        );
    }

    private <T> T executeRead(Function<Session, T> operation) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {
            return operation.apply(session);
        }
    }

    private <T> T executeInTransaction(Function<Session, T> operation) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Transaction transaction = session.beginTransaction();

            try {
                T result = operation.apply(session);
                transaction.commit();
                return result;
            } catch (RuntimeException exception) {
                if (transaction.isActive()) {
                    try {
                        transaction.rollback();
                    } catch (RuntimeException rollbackException) {
                        exception.addSuppressed(rollbackException);
                    }
                }

                throw exception;
            }
        }
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private static String escapeLike(String value) {
        return value
                .replace("!", "!!")
                .replace("%", "!%")
                .replace("_", "!_");
    }
}
