
package org.example.lms.member.repository;

import org.example.lms.config.DBConnection;
import org.example.lms.member.domain.Gender;
import org.example.lms.member.domain.Member;
import org.example.lms.member.domain.MemberStatus;
import org.example.lms.member.domain.MembershipType;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

public class MemberRepositoryImpl implements MemberRepository {

    private static final String SELECT_COLUMNS = """
            SELECT
                id,
                member_code,
                full_name,
                email,
                phone,
                date_of_birth,
                gender,
                address,
                membership_type,
                registration_date,
                valid_until,
                status,
                created_at,
                updated_at
            FROM members
            """;

    private static final String INSERT_SQL = """
            INSERT INTO members (
                member_code,
                full_name,
                email,
                phone,
                date_of_birth,
                gender,
                address,
                membership_type,
                registration_date,
                valid_until,
                status
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

    private static final String UPDATE_SQL = """
            UPDATE members
            SET
                member_code = ?,
                full_name = ?,
                email = ?,
                phone = ?,
                date_of_birth = ?,
                gender = ?,
                address = ?,
                membership_type = ?,
                registration_date = ?,
                valid_until = ?,
                status = ?
            WHERE id = ?
            """;

    // --------------------------------------------------
    // SAVE MEMBER: INSERT OR UPDATE
    // --------------------------------------------------

    @Override
    public Member save(Member member) {

        if (member == null) {
            throw new IllegalArgumentException(
                    "Member cannot be null."
            );
        }

        try (Connection connection =
                     DBConnection.getConnection()) {

            connection.setAutoCommit(false);

            try {

                Long memberId = member.getId();

                if (memberId == null) {

                    try (PreparedStatement statement =
                                 connection.prepareStatement(
                                         INSERT_SQL,
                                         Statement.RETURN_GENERATED_KEYS
                                 )) {

                        bindMember(statement, member);

                        int affectedRows = statement.executeUpdate();

                        if (affectedRows != 1) {
                            throw new SQLException(
                                    "Member insertion failed."
                            );
                        }

                        try (ResultSet keys =
                                     statement.getGeneratedKeys()) {

                            if (!keys.next()) {
                                throw new SQLException(
                                        "Unable to retrieve generated member ID."
                                );
                            }

                            memberId = keys.getLong(1);
                        }
                    }

                } else {

                    try (PreparedStatement statement =
                                 connection.prepareStatement(UPDATE_SQL)) {

                        bindMember(statement, member);
                        statement.setLong(12, memberId);

                        statement.executeUpdate();
                    }

                    if (findById(connection, memberId).isEmpty()) {
                        throw new SQLException(
                                "Member with ID " + memberId
                                        + " does not exist."
                        );
                    }
                }

                Member savedMember = findById(connection, memberId)
                        .orElseThrow(() ->
                                new SQLException(
                                        "Unable to retrieve saved member."
                                )
                        );

                connection.commit();

                return savedMember;

            } catch (SQLException | RuntimeException exception) {

                try {
                    connection.rollback();
                } catch (SQLException rollbackException) {
                    exception.addSuppressed(rollbackException);
                }

                throw exception;
            }

        } catch (SQLException exception) {
            throw databaseError("saving member", exception);
        }
    }

    // --------------------------------------------------
    // BIND MEMBER FIELDS
    // --------------------------------------------------

    private void bindMember(
            PreparedStatement statement,
            Member member
    ) throws SQLException {

        statement.setString(1, member.getMemberCode());
        statement.setString(2, member.getFullName());
        statement.setString(3, member.getEmail());
        statement.setString(4, member.getPhone());

        if (member.getDateOfBirth() != null) {
            statement.setDate(
                    5,
                    Date.valueOf(member.getDateOfBirth())
            );
        } else {
            statement.setNull(5, Types.DATE);
        }

        if (member.getGender() != null) {
            statement.setString(6, member.getGender().name());
        } else {
            statement.setNull(6, Types.VARCHAR);
        }

        statement.setString(7, member.getAddress());

        if (member.getMembershipType() == null) {
            throw new IllegalArgumentException(
                    "Membership type cannot be null."
            );
        }

        statement.setString(
                8,
                member.getMembershipType().name()
        );

        if (member.getRegistrationDate() == null
                || member.getValidUntil() == null) {
            throw new IllegalArgumentException(
                    "Registration date and validity date are required."
            );
        }

        statement.setDate(
                9,
                Date.valueOf(member.getRegistrationDate())
        );

        statement.setDate(
                10,
                Date.valueOf(member.getValidUntil())
        );

        if (member.getStatus() == null) {
            throw new IllegalArgumentException(
                    "Member status cannot be null."
            );
        }

        statement.setString(
                11,
                member.getStatus().name()
        );
    }

    // --------------------------------------------------
    // FIND MEMBER BY ID
    // --------------------------------------------------

    @Override
    public Optional<Member> findById(Long id) {

        if (id == null || id <= 0) {
            return Optional.empty();
        }

        String sql = SELECT_COLUMNS + " WHERE id = ?";

        try (Connection connection =
                     DBConnection.getConnection()) {

            return findOne(connection, sql, id);

        } catch (SQLException exception) {
            throw databaseError("finding member by ID", exception);
        }
    }

    // --------------------------------------------------
    // FIND MEMBER BY MEMBER CODE
    // --------------------------------------------------

    @Override
    public Optional<Member> findByMemberCode(String memberCode) {

        if (isBlank(memberCode)) {
            return Optional.empty();
        }

        String sql = SELECT_COLUMNS + " WHERE member_code = ?";

        try (Connection connection =
                     DBConnection.getConnection()) {

            return findOne(
                    connection,
                    sql,
                    memberCode.trim()
            );

        } catch (SQLException exception) {
            throw databaseError("finding member by code", exception);
        }
    }

    // --------------------------------------------------
    // FIND MEMBER BY EMAIL
    // --------------------------------------------------

    @Override
    public Optional<Member> findByEmail(String email) {

        if (isBlank(email)) {
            return Optional.empty();
        }

        String sql = SELECT_COLUMNS + " WHERE LOWER(email) = ?";

        try (Connection connection =
                     DBConnection.getConnection()) {

            return findOne(
                    connection,
                    sql,
                    email.trim().toLowerCase(Locale.ROOT)
            );

        } catch (SQLException exception) {
            throw databaseError("finding member by email", exception);
        }
    }

    // --------------------------------------------------
    // FIND ALL MEMBERS
    // --------------------------------------------------

    @Override
    public List<Member> findAll() {

        return executeListQuery(
                SELECT_COLUMNS + " ORDER BY id DESC",
                statement -> {
                    // No parameters required.
                }
        );
    }

    // --------------------------------------------------
    // FIND MEMBERS BY STATUS
    // --------------------------------------------------

    @Override
    public List<Member> findByStatus(MemberStatus status) {

        if (status == null) {
            return findAll();
        }

        String sql = SELECT_COLUMNS
                + " WHERE status = ? ORDER BY id DESC";

        return executeListQuery(
                sql,
                statement -> statement.setString(
                        1,
                        status.name()
                )
        );
    }

    // --------------------------------------------------
    // SEARCH MEMBERS
    // --------------------------------------------------

    @Override
    public List<Member> search(String query) {

        if (isBlank(query)) {
            return findAll();
        }

        String pattern = createSearchPattern(query);

        String sql = SELECT_COLUMNS + """
                 WHERE LOWER(member_code) LIKE ? ESCAPE '!'
                    OR LOWER(full_name) LIKE ? ESCAPE '!'
                    OR LOWER(email) LIKE ? ESCAPE '!'
                    OR LOWER(phone) LIKE ? ESCAPE '!'
                 ORDER BY id DESC
                """;

        return executeListQuery(
                sql,
                statement -> bindSearchPattern(
                        statement,
                        pattern,
                        1
                )
        );
    }

    // --------------------------------------------------
    // SEARCH MEMBERS WITH STATUS FILTER
    // --------------------------------------------------

    @Override
    public List<Member> searchByQueryAndStatus(
            String query,
            MemberStatus status
    ) {

        boolean hasQuery = !isBlank(query);

        if (!hasQuery && status == null) {
            return findAll();
        }

        if (!hasQuery) {
            return findByStatus(status);
        }

        if (status == null) {
            return search(query);
        }

        String pattern = createSearchPattern(query);

        String sql = SELECT_COLUMNS + """
                 WHERE status = ?
                   AND (
                        LOWER(member_code) LIKE ? ESCAPE '!'
                     OR LOWER(full_name) LIKE ? ESCAPE '!'
                     OR LOWER(email) LIKE ? ESCAPE '!'
                     OR LOWER(phone) LIKE ? ESCAPE '!'
                   )
                 ORDER BY id DESC
                """;

        return executeListQuery(
                sql,
                statement -> {
                    statement.setString(1, status.name());

                    bindSearchPattern(
                            statement,
                            pattern,
                            2
                    );
                }
        );
    }

    // --------------------------------------------------
    // CHECK MEMBER CODE
    // --------------------------------------------------

    @Override
    public boolean existsByMemberCode(String memberCode) {

        if (isBlank(memberCode)) {
            return false;
        }

        return exists(
                "SELECT 1 FROM members WHERE member_code = ? LIMIT 1",
                memberCode.trim()
        );
    }

    // --------------------------------------------------
    // CHECK EMAIL
    // --------------------------------------------------

    @Override
    public boolean existsByEmail(String email) {

        if (isBlank(email)) {
            return false;
        }

        return exists(
                "SELECT 1 FROM members WHERE LOWER(email) = ? LIMIT 1",
                email.trim().toLowerCase(Locale.ROOT)
        );
    }

    // --------------------------------------------------
    // CHECK MEMBER CODE EXCLUDING CURRENT ID
    // --------------------------------------------------

    @Override
    public boolean existsByMemberCodeAndIdNot(
            String memberCode,
            Long id
    ) {

        if (isBlank(memberCode) || id == null) {
            return false;
        }

        return exists(
                """
                SELECT 1
                FROM members
                WHERE member_code = ? AND id <> ?
                LIMIT 1
                """,
                memberCode.trim(),
                id
        );
    }

    // --------------------------------------------------
    // CHECK EMAIL EXCLUDING CURRENT ID
    // --------------------------------------------------

    @Override
    public boolean existsByEmailAndIdNot(
            String email,
            Long id
    ) {

        if (isBlank(email) || id == null) {
            return false;
        }

        return exists(
                """
                SELECT 1
                FROM members
                WHERE LOWER(email) = ? AND id <> ?
                LIMIT 1
                """,
                email.trim().toLowerCase(Locale.ROOT),
                id
        );
    }

    // --------------------------------------------------
    // COMMON EXISTENCE CHECK
    // --------------------------------------------------

    private boolean exists(
            String sql,
            Object... parameters
    ) {

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            bindParameters(statement, parameters);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (SQLException exception) {
            throw databaseError(
                    "checking member existence",
                    exception
            );
        }
    }

    // --------------------------------------------------
    // COMMON SINGLE RECORD QUERY
    // --------------------------------------------------

    private Optional<Member> findOne(
            Connection connection,
            String sql,
            Object... parameters
    ) throws SQLException {

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            bindParameters(statement, parameters);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }

                return Optional.empty();
            }
        }
    }

    // --------------------------------------------------
    // FIND MEMBER BY ID USING EXISTING CONNECTION
    // --------------------------------------------------

    private Optional<Member> findById(
            Connection connection,
            Long id
    ) throws SQLException {

        return findOne(
                connection,
                SELECT_COLUMNS + " WHERE id = ?",
                id
        );
    }

    // --------------------------------------------------
    // COMMON LIST QUERY
    // --------------------------------------------------

    private List<Member> executeListQuery(
            String sql,
            SqlBinder binder
    ) {

        List<Member> members = new ArrayList<>();

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            binder.bind(statement);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    members.add(mapRow(resultSet));
                }
            }

            return members;

        } catch (SQLException exception) {
            throw databaseError(
                    "retrieving members",
                    exception
            );
        }
    }

    // --------------------------------------------------
    // MAP DATABASE ROW TO MEMBER OBJECT
    // --------------------------------------------------

    private Member mapRow(ResultSet resultSet) throws SQLException {

        Date dateOfBirth =
                resultSet.getDate("date_of_birth");

        Date registrationDate =
                resultSet.getDate("registration_date");

        Date validUntil =
                resultSet.getDate("valid_until");

        Timestamp createdAt =
                resultSet.getTimestamp("created_at");

        Timestamp updatedAt =
                resultSet.getTimestamp("updated_at");

        String genderValue =
                resultSet.getString("gender");

        Gender gender = genderValue == null
                ? null
                : Gender.valueOf(genderValue.trim().toUpperCase(Locale.ROOT));

        return Member.fromDatabase(
                resultSet.getLong("id"),
                resultSet.getString("member_code"),
                resultSet.getString("full_name"),
                resultSet.getString("email"),
                resultSet.getString("phone"),

                dateOfBirth == null
                        ? null
                        : dateOfBirth.toLocalDate(),

                gender,

                resultSet.getString("address"),

                MembershipType.valueOf(
                        resultSet.getString("membership_type")
                                .trim()
                                .toUpperCase(Locale.ROOT)
                ),

                registrationDate == null
                        ? null
                        : registrationDate.toLocalDate(),

                validUntil == null
                        ? null
                        : validUntil.toLocalDate(),

                MemberStatus.valueOf(
                        resultSet.getString("status")
                                .trim()
                                .toUpperCase(Locale.ROOT)
                ),

                createdAt == null
                        ? null
                        : createdAt.toLocalDateTime(),

                updatedAt == null
                        ? null
                        : updatedAt.toLocalDateTime()
        );
    }

    // --------------------------------------------------
    // BIND QUERY PARAMETERS
    // --------------------------------------------------

    private void bindParameters(
            PreparedStatement statement,
            Object... parameters
    ) throws SQLException {

        for (int i = 0; i < parameters.length; i++) {
            statement.setObject(i + 1, parameters[i]);
        }
    }

    // --------------------------------------------------
    // SEARCH PATTERN AND WILDCARD ESCAPING
    // --------------------------------------------------

    private String createSearchPattern(String query) {

        String escaped = query.trim()
                .toLowerCase(Locale.ROOT)
                .replace("!", "!!")
                .replace("%", "!%")
                .replace("_", "!_");

        return "%" + escaped + "%";
    }

    private void bindSearchPattern(
            PreparedStatement statement,
            String pattern,
            int startIndex
    ) throws SQLException {

        for (int i = 0; i < 4; i++) {
            statement.setString(startIndex + i, pattern);
        }
    }

    // --------------------------------------------------
    // INPUT VALIDATION UTILITY
    // --------------------------------------------------

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    // --------------------------------------------------
    // DATABASE ERROR HANDLING
    // --------------------------------------------------

    private IllegalStateException databaseError(
            String operation,
            SQLException exception
    ) {

        return new IllegalStateException(
                "Database error while " + operation + ".",
                exception
        );
    }

    // --------------------------------------------------
    // SQL PARAMETER BINDER
    // --------------------------------------------------

    @FunctionalInterface
    private interface SqlBinder {

        void bind(PreparedStatement statement)
                throws SQLException;
    }
}
