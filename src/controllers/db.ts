import { Pool } from "pg";

export const pool = new Pool({
  host: "aws-1-eu-west-1.pooler.supabase.com",  // ✅ session pooler host
  port: 5432,
  database: "postgres",
  user: "postgres.tnvqdxnfuwbtrvwtzvzv",          // ✅ IMPORTANT: project ref included
  password: "#Codedtechshots2nd",
  ssl: {
    rejectUnauthorized: false,
  },
});
