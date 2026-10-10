
package org.example.lms.member.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(
        name = "members",
        indexes = {
                @Index(name = "idx_members_status", columnList = "status"),
                @Index(name = "idx_members_phone", columnList = "phone"),
                @Index(name = "idx_members_full_name", columnList = "full_name"),
                @Index(
                        name = "idx_members_registration_date",
                        columnList = "registration_date"
                )
        }
)
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "member_code", nullable = false, unique = true, length = 30)
    private String memberCode;

    @Column(name = "full_name", nullable = false, length = 120)
    private String fullName;

    @Column(name = "email", nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "phone", nullable = false, length = 20)
    private String phone;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender", length = 20)
    private Gender gender;

    @Column(name = "address", length = 500)
    private String address;

    @Enumerated(EnumType.STRING)
    @Column(name = "membership_type", nullable = false, length = 30)
    private MembershipType membershipType;

    @Column(name = "registration_date", nullable = false)
    private LocalDate registrationDate;

    @Column(name = "valid_until", nullable = false)
    private LocalDate validUntil;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private MemberStatus status = MemberStatus.ACTIVE;

    @Column(
            name = "created_at",
            nullable = false,
            insertable = false,
            updatable = false
    )
    private LocalDateTime createdAt;

    @Column(
            name = "updated_at",
            nullable = false,
            insertable = false,
            updatable = false
    )
    private LocalDateTime updatedAt;

    /**
     * Required by JPA providers.
     */
    protected Member() {
    }

    public Member(
            String memberCode,
            String fullName,
            String email,
            String phone,
            MembershipType membershipType,
            LocalDate registrationDate,
            LocalDate validUntil
    ) {
        this.memberCode = requireText(memberCode, "Member code");
        this.fullName = requireText(fullName, "Full name");
        this.email = requireText(email, "Email");
        this.phone = requireText(phone, "Phone");
        this.membershipType = Objects.requireNonNull(
                membershipType, "Membership type is required"
        );
        this.registrationDate = Objects.requireNonNull(
                registrationDate, "Registration date is required"
        );
        this.validUntil = Objects.requireNonNull(
                validUntil, "Membership expiry date is required"
        );

        validateMembershipPeriod();
    }

    private static String requireText(String value, String fieldName) {
        Objects.requireNonNull(value, fieldName + " is required");

        if (value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " cannot be blank");
        }

        return value;
    }

    private void validateMembershipPeriod() {
        if (registrationDate != null
                && validUntil != null
                && validUntil.isBefore(registrationDate)) {
            throw new IllegalArgumentException(
                    "Membership expiry date cannot precede registration date"
            );
        }
    }

    public Long getId() {
        return id;
    }

    public String getMemberCode() {
        return memberCode;
    }

    public void setMemberCode(String memberCode) {
        this.memberCode = requireText(memberCode, "Member code");
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = requireText(fullName, "Full name");
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = requireText(email, "Email");
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = requireText(phone, "Phone");
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public MembershipType getMembershipType() {
        return membershipType;
    }

    public void setMembershipType(MembershipType membershipType) {
        this.membershipType = Objects.requireNonNull(
                membershipType, "Membership type is required"
        );
    }

    public LocalDate getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDate registrationDate) {
        this.registrationDate = Objects.requireNonNull(
                registrationDate, "Registration date is required"
        );
        validateMembershipPeriod();
    }

    public LocalDate getValidUntil() {
        return validUntil;
    }

    public void setValidUntil(LocalDate validUntil) {
        this.validUntil = Objects.requireNonNull(
                validUntil, "Membership expiry date is required"
        );
        validateMembershipPeriod();
    }

    public MemberStatus getStatus() {
        return status;
    }

    public void setStatus(MemberStatus status) {
        this.status = Objects.requireNonNull(
                status, "Member status is required"
        );
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}
