# Self-Healing Selenium Robot Framework

This project implements a next-gen automated testing framework with a "Zero-Maintenance" goal using a Dual-Layer AI approach.

## Features
- **Level 2 Healing**: Uses Healenium (LCS Algorithm) to catch `NoSuchElementException` and self-heal based on DOM analysis.
- **Level 3 Healing**: Uses GenAI (LLM) as a fallback rescuer if Healenium fails. It analyzes the raw HTML to find the semantic match.
- **Level 4 Maintenance**: Automated feedback loop. Logs all healing events to `healing_log.json`.
- **Level 5 Agentic Live-Update**: The system is **Self-Correcting**. When GenAI finds a fix, it **automatically updates the JSON Page Object file** in real-time.

## Architecture
This project uses a **JSON-based Page Object Model (POM)**.
- Locators are stored in `locators/[PageName].json`.
- Tests reference them by Page Name and Element Name.

## Setup
1. **Python Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
2. **Infrastructure (Level 2 - Healenium)**:
   *Required for Level 2 Healing. If skipped, framework defaults to Level 3/5.*
   ```bash
   cd docker
   docker-compose up -d
   ```
3. **Configuration**:
   - Create a `.env` file with `GEMINI_API_KEY=your_key_here`.
   - To enable Healenium (Level 2), set `USE_HEALENIUM=True` in `resources/common.robot`.

## Execution
Run the demo suite:
```bash
robot -d results tests/self_healing_demo.robot
```

## How It Works (Agentic Flow)
1. **Fail**: Test fails to find an element (e.g., ID changed).
2. **Heal**: GenAI analyzes the page and finds the new locator.
3. **Update**: The agent **automatically updates** the `locators/*.json` file.
4. **Pass**: The test continues successfully. The code is fixed permanently.
