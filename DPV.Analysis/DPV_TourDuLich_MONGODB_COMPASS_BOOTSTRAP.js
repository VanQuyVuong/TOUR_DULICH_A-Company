// =============================================================
// DPV TourDuLich - MongoDB Compass Playground bootstrap
// =============================================================
// Purpose:
//   Create the DPV_TourDuLich database structure, essential indexes,
//   and the initial confirmed role catalog data.
//
// How to run in MongoDB Compass:
//   1. Connect to MongoDB.
//   2. Open Playgrounds -> New Playground.
//   3. Open/copy this file, then click Run.
//
// Safe to run more than once:
//   - Existing collections are preserved.
//   - Existing indexes are preserved.
//   - Seed documents are inserted only when their code is missing.
//
// This is NOT a migration of existing MySQL records. It intentionally
// creates no user account and no password. Account registration belongs
// to the API, where BCrypt hashing and authorization are enforced.
// =============================================================

// Kept separate from the old table-for-table import named DPV_TourDuLich.
const databaseName = "DPV_TourDuLich_Mongo";
const targetDb = db.getSiblingDB(databaseName);
const now = new Date();

// Collections follow the document design: small owned lists are embedded
// later (for example bookings.passengers and departures.itinerary), while
// independently queried/audited data is kept in its own collection.
const collectionNames = [
  "accounts", "roles", "permissions", "accountRoles", "rolePermissions",
  "employees", "departments", "employeeDepartments", "employeeLanguages",
  "customers", "guideSpecialties", "languages", "countries", "provinces",
  "locations", "tourTypes", "tours", "departures", "guideAssignments",
  "tourProgress", "cancellationPolicies", "bookings", "payments",
  "paymentReconciliations", "bookingCancellations", "refunds",
  "customTourRequests", "customTourAssignments", "customTourQuotations",
  "customTours", "departureBudgets", "expenses", "tourIncidents",
  "scheduleChangeRequests", "departureCancellations", "bookingTransfers",
  "tourReviews", "favoriteTours", "notifications", "systemLogs",
  "contactMessages", "loginSessions", "passwordResetTokens", "roleHistory"
];

const existingCollections = new Set(targetDb.getCollectionNames());
for (const name of collectionNames) {
  if (!existingCollections.has(name)) {
    targetDb.createCollection(name);
    print(`Created collection: ${name}`);
  }
}

function ensureIndex(collectionName, keys, options) {
  targetDb.getCollection(collectionName).createIndex(keys, options);
}

// Authentication, roles and organization
ensureIndex("accounts", { username: 1 }, { unique: true, name: "uq_accounts_username" });
ensureIndex("accounts", { email: 1 }, { unique: true, name: "uq_accounts_email" });
ensureIndex("roles", { code: 1 }, { unique: true, name: "uq_roles_code" });
ensureIndex("permissions", { code: 1 }, { unique: true, name: "uq_permissions_code" });
ensureIndex("accountRoles", { accountId: 1, roleId: 1 }, { unique: true, name: "uq_accountRoles_account_role" });
ensureIndex("rolePermissions", { roleId: 1, permissionId: 1 }, { unique: true, name: "uq_rolePermissions_role_permission" });
ensureIndex("employees", { accountId: 1 }, { unique: true, name: "uq_employees_accountId" });
ensureIndex("employees", { employeeCode: 1 }, { unique: true, name: "uq_employees_employeeCode" });
ensureIndex("departments", { code: 1 }, { unique: true, name: "uq_departments_code" });
ensureIndex("employeeDepartments", { employeeId: 1, departmentId: 1 }, { unique: true, name: "uq_employeeDepartments_employee_department" });
ensureIndex("employeeLanguages", { employeeId: 1, languageId: 1 }, { unique: true, name: "uq_employeeLanguages_employee_language" });
ensureIndex("customers", { accountId: 1 }, { unique: true, name: "uq_customers_accountId" });
ensureIndex("customers", { customerCode: 1 }, { unique: true, name: "uq_customers_customerCode" });
ensureIndex("guideSpecialties", { employeeId: 1, specialtyCode: 1 }, { unique: true, name: "uq_guideSpecialties_employee_specialty" });

// Master data
ensureIndex("languages", { code: 1 }, { unique: true, name: "uq_languages_code" });
ensureIndex("countries", { code: 1 }, { unique: true, name: "uq_countries_code" });
ensureIndex("provinces", { countryId: 1, name: 1 }, { name: "ix_provinces_country_name" });
ensureIndex("locations", { provinceId: 1, name: 1 }, { name: "ix_locations_province_name" });
ensureIndex("tourTypes", { code: 1 }, { unique: true, name: "uq_tourTypes_code" });

// Tours and departures
ensureIndex("tours", { tourCode: 1 }, { unique: true, name: "uq_tours_tourCode" });
ensureIndex("tours", { status: 1, tourTypeId: 1 }, { name: "ix_tours_status_tourType" });
ensureIndex("departures", { departureCode: 1 }, { unique: true, name: "uq_departures_departureCode" });
ensureIndex("departures", { tourId: 1, startAt: 1 }, { name: "ix_departures_tour_startAt" });
ensureIndex("departures", { status: 1, startAt: 1 }, { name: "ix_departures_status_startAt" });
ensureIndex("guideAssignments", { departureId: 1, employeeId: 1 }, { unique: true, name: "uq_guideAssignments_departure_employee" });
ensureIndex("tourProgress", { departureId: 1, createdAt: -1 }, { name: "ix_tourProgress_departure_createdAt" });

// Booking, payment, cancellation and refund
ensureIndex("bookings", { bookingCode: 1 }, { unique: true, name: "uq_bookings_bookingCode" });
ensureIndex("bookings", { customerId: 1, createdAt: -1 }, { name: "ix_bookings_customer_createdAt" });
ensureIndex("bookings", { departureId: 1, status: 1 }, { name: "ix_bookings_departure_status" });
ensureIndex("bookings", { status: 1, holdExpiresAt: 1 }, { name: "ix_bookings_status_holdExpiresAt" });
ensureIndex("payments", { transactionCode: 1 }, { unique: true, name: "uq_payments_transactionCode" });
ensureIndex("payments", { bookingId: 1, createdAt: -1 }, { name: "ix_payments_booking_createdAt" });
ensureIndex("paymentReconciliations", { paymentId: 1, createdAt: -1 }, { name: "ix_paymentReconciliations_payment_createdAt" });
ensureIndex("bookingCancellations", { bookingId: 1, createdAt: -1 }, { name: "ix_bookingCancellations_booking_createdAt" });
ensureIndex("refunds", { bookingId: 1, createdAt: -1 }, { name: "ix_refunds_booking_createdAt" });
ensureIndex("bookingTransfers", { bookingId: 1, createdAt: -1 }, { name: "ix_bookingTransfers_booking_createdAt" });
ensureIndex("tourReviews", { bookingId: 1 }, { unique: true, name: "uq_tourReviews_bookingId" });
ensureIndex("favoriteTours", { customerId: 1, tourId: 1 }, { unique: true, name: "uq_favoriteTours_customer_tour" });

// Operations, custom tours, notifications and audit
ensureIndex("customTourRequests", { customerId: 1, createdAt: -1 }, { name: "ix_customTourRequests_customer_createdAt" });
ensureIndex("customTourRequests", { status: 1, createdAt: -1 }, { name: "ix_customTourRequests_status_createdAt" });
ensureIndex("customTourAssignments", { requestId: 1, departmentId: 1 }, { name: "ix_customTourAssignments_request_department" });
ensureIndex("customTourQuotations", { requestId: 1, createdAt: -1 }, { name: "ix_customTourQuotations_request_createdAt" });
ensureIndex("customTours", { sourceRequestId: 1 }, { name: "ix_customTours_sourceRequestId" });
ensureIndex("departureBudgets", { departureId: 1 }, { unique: true, name: "uq_departureBudgets_departureId" });
ensureIndex("expenses", { departureId: 1, status: 1 }, { name: "ix_expenses_departure_status" });
ensureIndex("tourIncidents", { departureId: 1, createdAt: -1 }, { name: "ix_tourIncidents_departure_createdAt" });
ensureIndex("scheduleChangeRequests", { departureId: 1, status: 1 }, { name: "ix_scheduleChangeRequests_departure_status" });
ensureIndex("departureCancellations", { departureId: 1, createdAt: -1 }, { name: "ix_departureCancellations_departure_createdAt" });
ensureIndex("notifications", { recipientAccountId: 1, isRead: 1, createdAt: -1 }, { name: "ix_notifications_recipient_read_createdAt" });
ensureIndex("systemLogs", { createdAt: -1, action: 1 }, { name: "ix_systemLogs_createdAt_action" });
ensureIndex("contactMessages", { status: 1, createdAt: -1 }, { name: "ix_contactMessages_status_createdAt" });

// Security lifecycle. Only one-time reset tokens use TTL automatically.
ensureIndex("loginSessions", { refreshTokenHash: 1 }, { unique: true, name: "uq_loginSessions_refreshTokenHash" });
ensureIndex("loginSessions", { accountId: 1, status: 1 }, { name: "ix_loginSessions_account_status" });
ensureIndex("passwordResetTokens", { tokenHash: 1 }, { unique: true, name: "uq_passwordResetTokens_tokenHash" });
ensureIndex("passwordResetTokens", { expiresAt: 1 }, { expireAfterSeconds: 0, name: "ttl_passwordResetTokens_expiresAt" });
ensureIndex("roleHistory", { accountId: 1, createdAt: -1 }, { name: "ix_roleHistory_account_createdAt" });

// Seed data translated from the MySQL source. $setOnInsert prevents this
// bootstrap from overwriting data changed later by an administrator.
const roles = [
  ["ADMIN", "Quản trị viên", "Quản lý toàn bộ hệ thống"],
  ["QUAN_LY_TONG", "Quản lý tổng", "Quản lý tổng thể"],
  ["TRUONG_BAN", "Trưởng ban", "Quản lý một ban"],
  ["HDV", "Hướng dẫn viên", "Thực hiện tour"],
  ["NHAN_VIEN", "Nhân viên", "Nhân viên nội bộ"],
  ["KHACH_HANG", "Khách hàng", "Người sử dụng dịch vụ"]
];

for (const [code, name, description] of roles) {
  targetDb.roles.updateOne(
    { code },
    { $setOnInsert: { code, name, description, isActive: true, createdAt: now, updatedAt: now } },
    { upsert: true }
  );
}

// The business catalog for tour types has not been finally approved yet.
// Keep the tourTypes collection empty until the team explicitly approves seed data.

print(`MongoDB bootstrap completed for: ${databaseName}`);
print(`Collections available: ${targetDb.getCollectionNames().length}`);
print("Seeded catalog data: 6 confirmed system roles.");
