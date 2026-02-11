import { Router, Request, Response } from "express";
import { pool } from "../controllers/db";

const router = Router();

interface NssPersonnel {
  id?: number;
  name: string;
  department: string;
  number: string;
}
router.post("/nss", async (req: Request, res: Response) => {
  const { name, department, number }: NssPersonnel = req.body;

  if (!name || !department || !number) {
    return res.status(400).json({ message: "All fields are required" });
  }

  try {
    const result = await pool.query(
      "INSERT INTO nss_personnel (name, department, number) VALUES ($1, $2, $3) RETURNING *",
      [name, department, number]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Failed to create record" });
  }
});
router.get("/nss", async (req: Request, res: Response) => {
  try {
    const result = await pool.query("SELECT * FROM nss_personnel");
    res.json(result.rows);
  } catch (error) {
    console.error("DB ERROR:", error); // 👈 ADD THIS
    res.status(500).json({ error: "Failed to fetch records" });
  }
});

router.put("/nss/:id", async (req: Request, res: Response) => {
  const { id } = req.params;
  const { name, department, number }: NssPersonnel = req.body;

  try {
    const result = await pool.query(
      "UPDATE nss_personnel SET name=$1, department=$2, number=$3 WHERE id=$4 RETURNING *",
      [name, department, number, id]
    );

    res.json(result.rows[0]);
  } catch {
    res.status(500).json({ error: "Update failed" });
  }
});
router.delete("/nss/:id", async (req: Request, res: Response) => {
  const { id } = req.params;

  try {
    await pool.query(
      "DELETE FROM nss_personnel WHERE id=$1",
      [id]
    );

    res.json({ message: "Deleted successfully" });
  } catch {
    res.status(500).json({ error: "Delete failed" });
  }
});


export default router;
