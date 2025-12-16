import os
import sys
import time
import subprocess
from git import Repo, exc

# Ensure libraries path is in sys.path to import LocatorUpdater
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'libraries'))
import LocatorUpdater

REPO_PATH = "."

def run_git_workflow():
    print("Starting Automated PR Workflow...")
    
    # 1. Apply Updates
    LocatorUpdater.update_locators()
    
    # 2. Git Operations
    try:
        repo = Repo(REPO_PATH)
    except exc.InvalidGitRepositoryError:
        print(f"Error: {os.path.abspath(REPO_PATH)} is not a valid git repository.")
        print("Please initialize git: git init")
        return

    if not repo.is_dirty(untracked_files=True):
        print("No changes detected. Exiting.")
        return

    branch_name = f"heal/auto-fix-{int(time.time())}"
    print(f"Creating branch: {branch_name}")
    
    current = repo.active_branch
    new_branch = repo.create_head(branch_name)
    new_branch.checkout()
    
    print("Staging and committing changes...")
    repo.git.add(all=True)
    repo.index.commit("Auto-fix: Healed Selenium Locators")
    
    print(f"Committed changes to {branch_name}.")
    
    # 3. Push and PR (Mock or Real)
    print("\n--- Push & PR ---")
    print(f"To push: git push origin {branch_name}")
    print(f"To create PR: gh pr create --title 'Auto-fix Locators' --body 'AI-driven locator updates.'")
    
    # Attempt simple push if remote exists (commented out to avoid accidental pushes)
    # try:
    #     repo.remote().push(branch_name)
    # except Exception as e:
    #     print(f"Push failed (remote might not exist): {e}")

    # Return to original branch
    current.checkout()
    print("Workflow finished.")

if __name__ == "__main__":
    run_git_workflow()
