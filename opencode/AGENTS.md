# Global Rules

- Never commit file unless asked.
- Never start implementing without asked / confirmation.
- Always use a virtual env for python requirements.

## Global Agent Security Policy

- No agent may download or install any package, library, software, or dependency by any means (e.g. `npm install`, `pip install`, `apt-get install`, `curl`, `wget`, scripts, or binary installers) without explicit user approval for that specific action.
- All agents must confirm and record user approval before proceeding with any install or download.
- Any violation must immediately terminate the agent's action.

> This policy is absolute and cannot be bypassed for any reason.
