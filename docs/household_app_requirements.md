# Household Budget App Requirements

## Context
The app is built with Riverpod, Freezed, go_router, and Firebase (Firestore). Repository interfaces hide Firestore dependencies; ViewModels use provider/notifier patterns. Email-based Firebase Authentication already exists. Existing app flow and patterns should be followed.

## Functional Requirements
- **Household Sharing**: Invitation-based per household/book. No role/permission distinctions; all invited users can edit.
- **Home Tab**: Create/update/delete income and expense entries. Display monthly income/expense totals and summary. Input supports amount, date/time, category (predefined defaults), multiple tags, purchase-place tag, memo, and income/expense type.
- **Calendar Tab**: Monthly calendar with per-day totals. Tapping a date shows a detail list for that day (category, amount, tags, purchase tag, memo, creator, time). Detail list is read-only (no edit/delete actions).
- **TODO Tab**: Items have category, title, and due date. Status is either complete or incomplete; completed items show a check icon. Support add, toggle complete, and delete.
- **Graph Tab**: Monthly pie chart. Can switch aggregation between category and tag. Below the chart, show the income/expense list for the selected month.
- **Tags**: Tags are selectable in multiples, with color and icon settings. Purchase-place tags are a tag type used to speed re-entry and can be used for search/aggregation.
- **Standard Categories**: Use existing predefined categories and colors from the app theme (TunaguColors). Icons use Material Symbols.
- **Invites**: Align with existing invite UI/flow. If not present, implement a suitable invite flow (e.g., email/link) consistent with current patterns.

## Non-Functional Requirements
- Currency: Japanese Yen; locale/timezone: Japan. No multi-currency support.
- No offline mode; all data stored in Firestore. Validation is intentionally omitted.
- Follow existing routing (go_router) and state management patterns.

## Data Model Notes
- **Entry**: id, bookId, type (income/expense), amount, dateTime, categoryId, tagIds[], purchaseTagId?, memo, createdBy, createdAt, updatedAt.
- **Tag**: id, bookId, name, color, icon, type (standard/purchase-place). Supports multiple selection.
- **Category**: id, bookId, name, icon, color, isDefault (for standard categories from theme colors and Material Symbols icons).
- **Todo**: id, bookId, categoryId, title, dueDate, status (complete/incomplete), createdAt, updatedAt.
- **Aggregate**: Monthly/daily totals; category/tag-based monthly aggregation for graphs (client-side calculation).

## UI Flow
1. Launch → email auth → household selection/invite accept → tab navigation (Home/Calendar/TODO/Graph).
2. Home: choose month, enter income/expense → summary updates.
3. Calendar: browse month → tap date to view read-only daily entry list.
4. TODO: list → add, toggle completion, delete.
5. Graph: choose month → pie chart (category/tag) + monthly income/expense list.

## Implementation Notes for Agent Mode
- Keep Firestore access behind repository interfaces; domain/provider layers consume abstractions.
- Preserve existing directory structure, naming, and DI patterns. Update Freezed models with copyWith/JSON support as needed.
- Do not add validation or offline behavior. Handle Firestore failures per existing patterns (e.g., snackbars) if present.
- Use TunaguColors for category colors and Material Symbols for icons. Maintain go_router tab structure.
