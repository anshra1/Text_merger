<!-- Last Edited: 2025-08-11 14:38:00 -->
<!-- Edit History: 
     - 2025-08-11 14:38:00: Added 80-character line limit rule - Purpose: 
Improve readability and maintain consistent formatting
     - 2025-08-11 14:35:00: Updated edit tracking rule to include purpose 
documentation - Purpose: Improve audit trail by documenting both what 
changed and why
-->

# Claude Global Project Rules

## ⚠️ **CRITICAL SAFETY RULE - DELETE CONFIRMATION REQUIRED**

### **Mandatory Delete Protection**
**Before performing ANY of the following actions, Claude MUST stop and request explicit "delete" confirmation:**

- Deleting any files or directories
- Removing existing code blocks or functions
- Modifying existing files in destructive ways
- Clearing or resetting data/configurations
- Overwriting existing content
- Running destructive commands (rm, git reset --hard, etc.)
- Deleting anything related to git or GitHub (branches, commits, repositories, workflows, etc.)

**Process:**
1. Claude identifies a destructive action is needed
2. Claude STOPS and explains what will be deleted/modified
3. Claude asks: "Type 'delete' to confirm this action"
4. User MUST type exactly "delete" (case-insensitive)
5. Only then can Claude proceed with the destructive action

**This rule applies GLOBALLY across ALL projects and sessions.**

## ⚠️ **UNIVERSAL EDIT TRACKING RULE**

### **Mandatory Edit History Documentation**
**For ANY file modification, creation, update, or deletion, Claude MUST:**

1. **Add edit tracking header at the top of every modified file:**
   ```
   <!-- Last Edited: YYYY-MM-DD HH:MM:SS -->
   <!-- Edit History: 
        - YYYY-MM-DD HH:MM:SS: [Brief description of changes] - Purpose: [Why 
   this change was made]
        - YYYY-MM-DD HH:MM:SS: [Brief description of changes] - Purpose: [Why 
   this change was made]  
        - YYYY-MM-DD HH:MM:SS: [Brief description of changes] - Purpose: [Why 
   this change was made]
   -->
   ```

2. **Maintain only the last 3 edit entries** (remove oldest entry when adding 4th edit)

3. **Use ISO 8601 format:** YYYY-MM-DD HH:MM:SS (e.g., 2025-08-11 14:30:25)

4. **Apply to ALL file types:** code files, configuration files, documentation, etc.

5. **Include brief change description AND purpose:** what was modified, added, deleted, or created AND why this change was necessary

6. **Enforce 80-character line limit:** Each comment line must not exceed 80 characters. Wrap long descriptions across multiple lines using appropriate comment syntax.

7. **Use appropriate comment syntax for each file type:**
   - HTML/XML: `<!-- -->`
   - JavaScript/CSS: `/* */` or `//`
   - Python: `#`
   - Dart: `//` or `/* */`
   - Shell scripts: `#`
   - Markdown: `<!-- -->`
   - etc.

**This tracking rule applies to EVERY file touched by AI, ensuring complete audit trail of all modifications.**