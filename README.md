# Course & Tutor API – Assignment Project

This is an **API-only Rails application** built to manage courses and their associated tutors.

---

## 🚀 Tech Stack

- **Ruby**: `3.3.1`
- **Rails**: `7.2.2.1` (API-only mode)
- **Database**: PostgreSQL
- **Environment Management**: [`dotenv-rails`](https://github.com/bkeepers/dotenv)
- **Authentication**: HTTP Basic Authentication

---

## 🔐 API Authentication

All API endpoints are protected via **Basic Auth**.

| Credential | Value        |
|------------|--------------|
| Username   | `ASSIGNMENT` |
| Password   | `ProMobi`    |

### 🔁 Example usage with curl:

```bash
curl -u ASSIGNMENT:ProMobi http://localhost:3000/api/v1/courses
