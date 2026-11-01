
package org.example.lms.member.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

public class Member {

    private Long id;

    private String memberCode;
    private String fullName;
    private String email;
    private String phone;

    private LocalDate dateOfBirth;
    private Gender gender;
    private String address;

    private MembershipType membershipType;

    private LocalDate registrationDate;
    private LocalDate validUntil;

    private MemberStatus status = MemberStatus.ACTIVE;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ==========================================
    // DEFAULT CONSTRUCTOR
    // ==========================================

    public Member() {
    }

    // ==========================================
    // CONSTRUCTOR
    // ==========================================

    public Member(
            String memberCode,
            String fullName,
            String email,
            String phone,
            LocalDate dateOfBirth,
            Gender gender,
            String address,
            MembershipType membershipType,
            LocalDate registrationDate,
            LocalDate validUntil,
            MemberStatus status
    ) {
        setMemberCode(memberCode);
        setFullName(fullName);
        setEmail(email);
        setPhone(phone);
        setDateOfBirth(dateOfBirth);
        setGender(gender);
        setAddress(address);
        setMembershipType(membershipType);
        setRegistrationDate(registrationDate);
        setValidUntil(validUntil);
        setStatus(status);
    }

    // ==========================================
    // DATABASE FACTORY METHOD
    // ==========================================

    public static Member fromDatabase(
            Long id,
            String memberCode,
            String fullName,
            String email,
            String phone,
            LocalDate dateOfBirth,
            Gender gender,
            String address,
            MembershipType membershipType,
            LocalDate registrationDate,
            LocalDate validUntil,
            MemberStatus status,
            LocalDateTime createdAt,
            LocalDateTime updatedAt
    ) {

        Member member = new Member();

        member.id = Objects.requireNonNull(
                id,
                "Member ID cannot be null."
        );

        member.memberCode = memberCode;
        member.fullName = fullName;
        member.email = email;
        member.phone = phone;

        member.dateOfBirth = dateOfBirth;
        member.gender = gender;
        member.address = address;

        member.membershipType = membershipType;

        member.registrationDate = registrationDate;
        member.validUntil = validUntil;

        member.status = status;

        member.createdAt = createdAt;
        member.updatedAt = updatedAt;

        return member;
    }

    // ==========================================
    // GETTERS
    // ==========================================

    public Long getId() {
        return id;
    }

    public String getMemberCode() {
        return memberCode;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public Gender getGender() {
        return gender;
    }

    public String getAddress() {
        return address;
    }

    public MembershipType getMembershipType() {
        return membershipType;
    }

    public LocalDate getRegistrationDate() {
        return registrationDate;
    }

    public LocalDate getValidUntil() {
        return validUntil;
    }

    public MemberStatus getStatus() {
        return status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    // ==========================================
    // SETTERS
    // ==========================================

    public void setId(Long id) {
        this.id = id;
    }

    public void setMemberCode(String memberCode) {
        this.memberCode = requireText(
                memberCode,
                "Member code"
        );
    }

    public void setFullName(String fullName) {
        this.fullName = requireText(
                fullName,
                "Full name"
        );
    }

    public void setEmail(String email) {
        this.email = requireText(
                email,
                "Email"
        ).toLowerCase(java.util.Locale.ROOT);
    }

    public void setPhone(String phone) {
        this.phone = requireText(
                phone,
                "Phone"
        );
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setMembershipType(MembershipType membershipType) {
        this.membershipType = Objects.requireNonNull(
                membershipType,
                "Membership type is required."
        );
    }

    public void setRegistrationDate(LocalDate registrationDate) {
        this.registrationDate = Objects.requireNonNull(
                registrationDate,
                "Registration date is required."
        );
    }

    public void setValidUntil(LocalDate validUntil) {
        this.validUntil = Objects.requireNonNull(
                validUntil,
                "Membership validity date is required."
        );
    }

    public void setStatus(MemberStatus status) {
        this.status = Objects.requireNonNull(
                status,
                "Member status is required."
        );
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // ==========================================
    // VALIDATION UTILITY
    // ==========================================

    private static String requireText(
            String value,
            String fieldName
    ) {

        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(
                    fieldName + " cannot be empty."
            );
        }

        return value.trim();
    }

    // ==========================================
    // OBJECT METHODS
    // ==========================================

    @Override
    public String toString() {
        return "Member{" +
                "id=" + id +
                ", memberCode='" + memberCode + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", membershipType=" + membershipType +
                ", status=" + status +
                '}';
    }
}
