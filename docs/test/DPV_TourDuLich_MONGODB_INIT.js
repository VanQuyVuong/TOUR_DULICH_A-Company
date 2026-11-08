// =============================================================
// DPV_TourDuLich - MongoDB bootstrap (initial scaffold)
// Run with mongosh: mongosh "mongodb://127.0.0.1:27017" DPV_TourDuLich --file DPV_TourDuLich_MONGODB_INIT.js
// IMPORTANT: Creates collections and indexes only. It does NOT migrate SQL data
// and does NOT yet enforce all final document validators/business constraints.
// =============================================================

const dbName = "DPV_TourDuLich";
const targetDb = db.getSiblingDB(dbName);

const collections = [
  "accounts", "roles", "permissions", "accountRoles", "rolePermissions",
  "employees", "departments", "employeeDepartments", "employeeLanguages",
  "customers", "guideSpecialties", "languages", "countries", "provinces",
  "locations", "tourTypes", "tours", "departures", "guideAssignments",
  "tourProgress", "cancellationPolicies", "bookings", "payments",
  "paymentReconciliations", "bookingCancellations", "refunds",
  "customTourRequests", "customTourAssignments", "customTourQuotations", "customTours",
  "departureBudgets", "expenses", "tourIncidents", "scheduleChangeRequests",
  "departureCancellations", "bookingTransfers", "tourReviews", "favoriteTours",
  "notifications", "systemLogs", "contactMessages", "loginSessions",
  "passwordResetTokens", "roleHistory"
];

const existing = new Set(targetDb.getCollectionNames());
for (const name of collections) {
  if (!existing.has(name)) {
    targetDb.createCollection(name);
    print(`Created collection: ${name}`);
  } else {
    print(`Exists, skipped: ${name}`);
  }
}

function idx(collection, keys, options = {}) {
  targetDb.getCollection(collection).createIndex(keys, options);
}

// Account, authorization and employee records
idx("accounts", { username: 1 }, { unique: true, name: "uq_accounts_username" });
idx("accounts", { email: 1 }, { unique: true, name: "uq_accounts_email" });
idx("roles", { code: 1 }, { unique: true, name: "uq_roles_code" });
idx("permissions", { code: 1 }, { unique: true, name: "uq_permissions_code" });
idx("employees", { accountId: 1 }, { unique: true, name: "uq_employees_accountId" });
idx("employees", { employeeCode: 1 }, { unique: true, name: "uq_employees_employeeCode" });
idx("departments", { code: 1 }, { unique: true, name: "uq_departments_code" });
idx("customers", { accountId: 1 }, { unique: true, name: "uq_customers_accountId" });
idx("guideSpecialties", { employeeId: 1, specialtyCode: 1 }, { unique: true, name: "uq_guideSpecialties_employee_specialty" });
idx("languages", { code: 1 }, { unique: true, name: "uq_languages_code" });
idx("countries", { code: 1 }, { unique: true, name: "uq_countries_code" });
idx("provinces", { countryId: 1, name: 1 }, { name: "ix_provinces_country_name" });
idx("locations", { provinceId: 1, name: 1 }, { name: "ix_locations_province_name" });
idx("tourTypes", { code: 1 }, { unique: true, name: "uq_tourTypes_code" });

// Many-to-many relations kept separately until access patterns are confirmed
idx("accountRoles", { accountId: 1, roleId: 1 }, { unique: true, name: "uq_accountRoles_account_role" });
idx("rolePermissions", { roleId: 1, permissionId: 1 }, { unique: true, name: "uq_rolePermissions_role_permission" });
idx("employeeDepartments", { employeeId: 1, departmentId: 1 }, { unique: true, name: "uq_employeeDepartments_employee_department" });
idx("employeeLanguages", { employeeId: 1, languageId: 1 }, { unique: true, name: "uq_employeeLanguages_employee_language" });

// Tours and departures
idx("tours", { code: 1 }, { unique: true, name: "uq_tours_code" });
idx("tours", { status: 1, tourTypeId: 1 }, { name: "ix_tours_status_type" });
idx("tours", { createdByEmployeeId: 1 }, { name: "ix_tours_createdBy" });
idx("departures", { code: 1 }, { unique: true, name: "uq_departures_code" });
idx("departures", { tourId: 1, startAt: 1 }, { name: "ix_departures_tour_startAt" });
idx("departures", { status: 1, startAt: 1 }, { name: "ix_departures_status_startAt" });
idx("guideAssignments", { departureId: 1, employeeId: 1 }, { unique: true, name: "uq_guideAssignments_departure_employee" });
idx("tourProgress", { departureId: 1, createdAt: -1 }, { name: "ix_tourProgress_departure_createdAt" });

// Booking and money flows
idx("bookings", { code: 1 }, { unique: true, name: "uq_bookings_code" });
idx("bookings", { customerId: 1, createdAt: -1 }, { name: "ix_bookings_customer_createdAt" });
idx("bookings", { departureId: 1, status: 1 }, { name: "ix_bookings_departure_status" });
idx("bookings", { status: 1, holdExpiresAt: 1 }, { name: "ix_bookings_status_holdExpiresAt" });
idx("payments", { transactionCode: 1 }, { unique: true, name: "uq_payments_transactionCode" });
idx("payments", { bookingId: 1, createdAt: -1 }, { name: "ix_payments_booking_createdAt" });
idx("paymentReconciliations", { paymentId: 1, createdAt: -1 }, { name: "ix_paymentReconciliations_payment_createdAt" });
idx("bookingCancellations", { bookingId: 1, createdAt: -1 }, { name: "ix_bookingCancellations_booking_createdAt" });
idx("refunds", { bookingId: 1, createdAt: -1 }, { name: "ix_refunds_booking_createdAt" });
idx("refunds", { paymentId: 1 }, { name: "ix_refunds_paymentId" });
idx("bookingTransfers", { bookingId: 1, createdAt: -1 }, { name: "ix_bookingTransfers_booking_createdAt" });
idx("tourReviews", { bookingId: 1 }, { unique: true, name: "uq_tourReviews_bookingId" });
idx("tourReviews", { tourId: 1, createdAt: -1 }, { name: "ix_tourReviews_tour_createdAt" });
idx("favoriteTours", { customerId: 1, tourId: 1 }, { unique: true, name: "uq_favoriteTours_customer_tour" });

// Custom tours, budgets, expenses and incidents
idx("customTourRequests", { customerId: 1, createdAt: -1 }, { name: "ix_customTourRequests_customer_createdAt" });
idx("customTourRequests", { status: 1, createdAt: -1 }, { name: "ix_customTourRequests_status_createdAt" });
idx("customTourAssignments", { requestId: 1, departmentId: 1 }, { name: "ix_customTourAssignments_request_department" });
idx("customTourQuotations", { requestId: 1, createdAt: -1 }, { name: "ix_customTourQuotations_request_createdAt" });
idx("customTours", { sourceRequestId: 1 }, { name: "ix_customTours_sourceRequestId" });
idx("departureBudgets", { departureId: 1 }, { unique: true, name: "uq_departureBudgets_departureId" });
idx("expenses", { departureId: 1, status: 1 }, { name: "ix_expenses_departure_status" });
idx("tourIncidents", { departureId: 1, createdAt: -1 }, { name: "ix_tourIncidents_departure_createdAt" });
idx("scheduleChangeRequests", { departureId: 1, status: 1 }, { name: "ix_scheduleChangeRequests_departure_status" });
idx("departureCancellations", { departureId: 1, createdAt: -1 }, { name: "ix_departureCancellations_departure_createdAt" });

// Notifications, logs and authentication lifecycle
idx("notifications", { recipientAccountId: 1, isRead: 1, createdAt: -1 }, { name: "ix_notifications_recipient_read_createdAt" });
idx("systemLogs", { createdAt: -1, action: 1 }, { name: "ix_systemLogs_createdAt_action" });
idx("contactMessages", { status: 1, createdAt: -1 }, { name: "ix_contactMessages_status_createdAt" });
idx("loginSessions", { refreshTokenHash: 1 }, { unique: true, name: "uq_loginSessions_refreshTokenHash" });
idx("loginSessions", { accountId: 1, status: 1 }, { name: "ix_loginSessions_account_status" });
idx("passwordResetTokens", { tokenHash: 1 }, { unique: true, name: "uq_passwordResetTokens_tokenHash" });
idx("passwordResetTokens", { expiresAt: 1 }, { expireAfterSeconds: 0, name: "ttl_passwordResetTokens_expiresAt" });
idx("roleHistory", { accountId: 1, createdAt: -1 }, { name: "ix_roleHistory_account_createdAt" });

// NOTE: Do not add TTL indexes to loginSessions or booking holds until business
// rules explicitly define retention/expiry cleanup behavior.
print(`\nMongoDB bootstrap finished for database: ${dbName}`);
print(`Collections present: ${targetDb.getCollectionNames().length}`);
print("This script creates collection shells and indexes only; document schemas, validators, transactions, and migration are separate tasks.");
