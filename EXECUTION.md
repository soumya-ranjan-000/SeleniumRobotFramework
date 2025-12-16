# Execution Guide: Self-Healing Robot Framework

This guide will walk you through running the project, triggering self-healing, and creating a pull request.

## Prerequisites
1.  **Docker Desktop** (Installed and Running) - *Optional, only for Level 2*
2.  **Python 3.8+**
3.  **Gemini API Key** (Set as `GEMINI_API_KEY` env variable)
4.  **Git** (Configured for Level 4)

## Step 1: Install Dependencies
Open a terminal in the project root:
```bash
pip install -r requirements.txt
```

## Step 2: Start Infrastructure (Level 2)
This starts the Healenium Proxy and Backend.
*Note: If you skip this, ensure `USE_HEALENIUM` is `False` in `resources/common.robot`.*
```bash
cd docker
docker-compose up -d
```
> Wait about 30 seconds for the containers to fully start. You can check status with `docker ps`.

## Step 3: Run the Test (Break it!)
We have a test `tests/self_healing_demo.robot` that opens `mock_app.html`.
It references a Page Object `SelfHealingDemoPage.json` where the locator `submit_btn` points to the **old** ID (`submit-btn`).
The mock app changes that ID to `submit-v3-btn` after 5 seconds.

Run it:
```bash
# Ensure you are in the project root
# Windows (PowerShell)
$env:GEMINI_API_KEY="your-api-key"
robot -d results tests/self_healing_demo.robot
```

**What to Expect (Agentic Healing):**
1.  Browser opens.
2.  Test fails on `submit_btn` (Initial attempt).
3.  **GenAI Rescues**: Finds the new `submit-v3-btn`.
4.  **Live Update**: The system **automatically updates** `locators/SelfHealingDemoPage.json` with the new value.
5.  Test **PASSES**.

## Step 4: Verify the Fix
Open `locators/SelfHealingDemoPage.json`. You will see it has been updated to:
```json
"submit_btn": {
  "type": "id", 
  "value": "submit-v3-btn"
}
```
Run the test again. It will pass immediately without needing to heal, because the code itself was fixed.
