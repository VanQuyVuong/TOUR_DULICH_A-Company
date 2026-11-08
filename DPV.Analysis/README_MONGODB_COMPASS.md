# MongoDB bootstrap for DPV TourDuLich

## File to run

Run `DPV_TourDuLich_MONGODB_COMPASS_BOOTSTRAP.js` in MongoDB Compass Playgrounds. It creates database `DPV_TourDuLich_Mongo`, 44 collections, the essential indexes, and seed data for six confirmed system roles.

This file is safe to run repeatedly. It does not drop a database, overwrite existing seed documents, create an administrator account, or store any password.

## MongoDB Compass steps

1. Connect Compass to the intended MongoDB server.
2. Choose **Playgrounds** then **New Playground**.
3. Open or paste `DPV_TourDuLich_MONGODB_COMPASS_BOOTSTRAP.js`.
4. Click **Run**.
5. Refresh the database list. `DPV_TourDuLich_Mongo` should appear.
6. Open `roles` to verify that it has six documents. `tourTypes` is created but deliberately not seeded until its catalog is approved.

Compass **Import Data** accepts JSON/CSV for one collection at a time. It cannot create many collections, indexes, and seed data from one JSON file. A Playground JavaScript file is therefore the correct single-file format for this project.

## Sources used for the design

- `DPV.Analysis/DPV.CSDL.sql`: 56-table relational source and confirmed role values.
- `docs/04_DPV_TourDuLich_USER_FUNCTION_SPEC_FINAL.md`: roles, functions, pages and ownership requirements.
- `docs/05_DPV_TourDuLich_FLOW_STATE_SPEC_FINAL.md`: authoritative workflows/states and transaction requirements.
- `docs/06_DPV_TourDuLich_QA_PERMISSION_API_CONTRACT_FINAL.md`: API, authorization, test and concurrency contract.
- `docs/DPV_TourDuLich_DEVELOPER_HANDOFF_FINAL.md`: security and integration rules.
- `docs/test/DPV_TourDuLich_MONGODB_DESIGN.md`: original MongoDB transition proposal.
- `UX_UI`: screens used as an additional check of required modules.
- `DPV.Analysis/Huong_dan_MongoDB_DPV_TourDuLich.docx`: current MongoDB assessment and the decision not to seed tour types before business confirmation.

## Main modelling choices

- `accounts`, `roles`, `permissions`, `accountRoles`, `rolePermissions`, `customers`, `employees` and login/reset collections are separate because they have independent security/audit lifecycles.
- `bookings.passengers`, `departures.itinerary`, `tours.destinations`, custom-tour requested locations and quotation items should be embedded arrays; their lifetime is owned by the parent document.
- Payment, refunds, incidents, schedule changes, notifications, logs and role history are separate collections because their history can grow indefinitely and must be queried/audited independently.
- All references use MongoDB `ObjectId`; business codes such as `tourCode`, `departureCode` and `bookingCode` have unique indexes.
- Dates are BSON UTC dates and money must use Decimal128 in the .NET model/driver, not `double`.

## Important implementation rules after bootstrap

- A customer registration must create `accounts` + `customers` + `accountRoles` for `KHACH_HANG` in one transaction.
- Booking must atomically check and reserve departure capacity. Payment callback processing must be idempotent.
- Password, refresh token and reset token values must be stored as hashes only.
- Multi-document transactions require a MongoDB replica set (including local development), not a standalone server.
- The current ASP.NET backend is still configured for EF Core/MySQL. Before continuing feature work, replace the MySQL provider/`UseMySql`/`DbContext` path with `MongoDB.Driver` and MongoDB repository/service code. Do not run the old SQL script as the active database schema.

## Files not to run as the new database source

`DPV.Analysis/DPV_TourDuLich.js` is an earlier incomplete, table-for-table conversion draft. It does not reflect the final embedded-versus-reference document design. Keep it only as historical reference.
