# 📘 Documentation for `features/code_combiner`

> Describe this module’s purpose, structure, and business logic here.
🧠 App Description – Code Combiner
🔷 What the App Does
The Code Combiner is a Flutter desktop app that allows developers to:
Visually select files and folders from their project using a familiar, tree-style file system.
Inspect and combine contents of the selected files into a clean, structured, and readable format.
Easily export that structured code — either by copying to clipboard or saving as a .txt file — to paste into tools like ChatGPT, Gemini, Copilot, or other AI assistants for prompt engineering, code explanation, or refactoring.
💥 Core Problem Solved

“I want AI to understand my code, but manually selecting, cleaning, and structuring relevant parts every time is time-consuming and messy.”
Today, developers waste time:
Manually navigating folders to copy/paste code snippets
Cleaning out irrelevant files or binary files
Struggling to format multiple files as a single understandable block for AI models
Repeating this every time they need help from AI coding tools
✅ Solution / Value Provided
Your app:
📂 Simplifies file selection: with a visual tree picker + multi-select checkbox support
✨ Auto-cleans and structures code: adds file separators like === file_name.dart ===
🚫 Skips binary or noisy files: auto-ignore .png, .iml, .lock, etc.
⚙️ Gives control: via settings to include/exclude specific file types/extensions
📋 Improves AI prompt workflows: the final combined code is readable, shareable, and works well as an input for AI models
🔍 Ideal Use Cases
Sending multiple related files to ChatGPT/Gemini to ask for help
Preparing code snippets to debug with a team or code reviewer
Creating reproducible bug reports or MWE (Minimal Working Examples)
Onboarding: showing a curated part of a codebase to a new developer
🧰 Who It’s For
Professional developers
Prompt engineers
AI-powered software creators
Technical leads and architects





