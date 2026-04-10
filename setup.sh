#!/usr/bin/env bash
# ============================================================
# Vet Challenge VR — Environment Setup Script
# Run once after cloning to verify your development environment.
# ============================================================
set -uo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=============================================="
echo "  Vet Challenge VR — Environment Check"
echo "=============================================="
echo ""

ERRORS=0

# ---- 1. Check Android SDK ----
echo -n "🔍 Android SDK... "
if [ -d "$SCRIPT_DIR/sdk-android" ] && [ -L "$SCRIPT_DIR/sdk-android/current-sdk" ]; then
    SDK_TARGET=$(readlink "$SCRIPT_DIR/sdk-android/current-sdk")
    if [ -d "$SDK_TARGET" ]; then
        echo -e "${GREEN}OK${NC} → $SDK_TARGET"
    else
        echo -e "${RED}BROKEN SYMLINK${NC} → $SDK_TARGET does not exist"
        ERRORS=$((ERRORS+1))
    fi
else
    echo -e "${RED}NOT FOUND${NC}"
    echo "   Create a symlink: ln -s /path/to/your/android-sdk sdk-android/current-sdk"
    ERRORS=$((ERRORS+1))
fi

# ---- 2. Check Java ----
echo -n "🔍 Java (JDK 17+)... "
if command -v java &> /dev/null; then
    JAVA_VER=$(java -version 2>&1 | head -1 | awk -F '"' '{print $2}')
    echo -e "${GREEN}OK${NC} → $JAVA_VER"
else
    echo -e "${YELLOW}NOT FOUND${NC} (optional for local builds; Docker handles this)"
fi

# ---- 3. Check Docker ----
echo -n "🔍 Docker... "
if command -v docker &> /dev/null; then
    DOCKER_VER=$(docker --version | awk '{print $3}' | tr -d ',')
    echo -e "${GREEN}OK${NC} → $DOCKER_VER"
else
    echo -e "${YELLOW}NOT FOUND${NC} (install Docker Desktop for container-based builds)"
fi

# ---- 4. Check Unity Hub ----
echo -n "🔍 Unity Hub... "
if [ -d "/Applications/Unity Hub.app" ]; then
    echo -e "${GREEN}INSTALLED${NC}"
elif [ -f "$SCRIPT_DIR/UnityHubSetup-arm64.dmg" ]; then
    echo -e "${YELLOW}DMG FOUND${NC} — not yet installed"
    echo "   Run: open $SCRIPT_DIR/UnityHubSetup-arm64.dmg"
else
    echo -e "${RED}NOT FOUND${NC}"
    ERRORS=$((ERRORS+1))
fi

# ---- 5. Check Unity Editor ----
echo -n "🔍 Unity Editor (2022.3 LTS)... "
UNITY_EDITORS_DIR="/Applications/Unity/Hub/Editor"
if [ -d "$UNITY_EDITORS_DIR" ]; then
    EDITORS=$(ls "$UNITY_EDITORS_DIR" 2>/dev/null || echo "")
    if [ -n "$EDITORS" ]; then
        echo -e "${GREEN}OK${NC} → $EDITORS"
    else
        echo -e "${YELLOW}NO EDITORS INSTALLED${NC}"
        echo "   Install Unity 2022.3.22f1 via Unity Hub → Installs → Add"
    fi
else
    echo -e "${YELLOW}NO EDITORS INSTALLED${NC}"
    echo "   Install Unity 2022.3.22f1 via Unity Hub → Installs → Add"
fi

# ---- 6. Check Project Structure ----
echo ""
echo "📁 Project Structure:"

check_dir() {
    if [ -d "$SCRIPT_DIR/$1" ]; then
        echo -e "   ${GREEN}✓${NC} $1/"
    else
        echo -e "   ${RED}✗${NC} $1/ — MISSING"
        ERRORS=$((ERRORS+1))
    fi
}

check_file() {
    if [ -f "$SCRIPT_DIR/$1" ]; then
        echo -e "   ${GREEN}✓${NC} $1"
    else
        echo -e "   ${RED}✗${NC} $1 — MISSING"
        ERRORS=$((ERRORS+1))
    fi
}

echo "   Unity:"
check_dir  "Assets/Scripts"
check_dir  "ProjectSettings"
check_dir  "Packages"
check_file "ProjectSettings/ProjectVersion.txt"
check_file "Packages/manifest.json"

echo "   Unreal:"
check_file "Unreal/VetChallenge.uproject"
check_dir  "Unreal/Source/VetChallenge"
check_file "Unreal/Source/VetChallenge/ScoreLogic.h"
check_file "Unreal/Source/VetChallenge/ScoreLogic.cpp"

# ---- Summary ----
echo ""
echo "=============================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Ready to develop.${NC}"
    echo ""
    echo "Next steps:"
    echo "  Unity  → Open Unity Hub → Add project from: $SCRIPT_DIR"
    echo "  Unreal → Open UE5 → Browse to: $SCRIPT_DIR/Unreal/VetChallenge.uproject"
    echo "  Docker → docker build -t vetchallenge-vr ."
else
    echo -e "${RED}⚠ $ERRORS issue(s) found. Fix them and re-run this script.${NC}"
fi
echo "=============================================="

exit $ERRORS
