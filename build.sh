#!/bin/bash

# 設定顏色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
PRODUCTION_API_URL="https://avapp-760426583552.asia-east1.run.app"
FLUTTER_PROJECT_DIR="flutter/avplayer_app"
OUTPUT_DIR="build/app/outputs/flutter-apk"
APK_NAME="avplayer-release"
GITHUB_REPO="gwolf0719/avapp"  # 請替換為您的 GitHub 倉庫

echo -e "${BLUE}=== AVPlayer 正式版 APK 構建腳本 ===${NC}"
echo -e "${BLUE}正式 API URL: $PRODUCTION_API_URL${NC}"
echo ""

# 檢查必要工具
check_requirements() {
    echo -e "${BLUE}檢查必要工具...${NC}"
    
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}錯誤：Flutter 未安裝或不在 PATH 中${NC}"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        echo -e "${RED}錯誤：Git 未安裝${NC}"
        exit 1
    fi
    
    if ! command -v gh &> /dev/null; then
        echo -e "${YELLOW}警告：GitHub CLI (gh) 未安裝，將無法自動發布到 GitHub${NC}"
        echo "請安裝 GitHub CLI: https://cli.github.com/"
        read -p "是否繼續構建 APK？(y/N): " continue_build
        if [[ ! $continue_build =~ ^[Yy]$ ]]; then
            exit 1
        fi
        SKIP_GITHUB_RELEASE=true
    fi
    
    echo -e "${GREEN}✓ 工具檢查完成${NC}"
}

# 獲取版本資訊
get_version_info() {
    echo -e "${BLUE}獲取版本資訊...${NC}"
    
    cd "$FLUTTER_PROJECT_DIR"
    
    # 從 pubspec.yaml 獲取版本
    VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')
    if [ -z "$VERSION" ]; then
        echo -e "${RED}錯誤：無法從 pubspec.yaml 獲取版本資訊${NC}"
        exit 1
    fi
    
    # 獲取 Git commit hash
    COMMIT_HASH=$(git rev-parse --short HEAD)
    BUILD_DATE=$(date +"%Y%m%d-%H%M%S")
    
    echo -e "${GREEN}版本: $VERSION${NC}"
    echo -e "${GREEN}Commit: $COMMIT_HASH${NC}"
    echo -e "${GREEN}構建時間: $BUILD_DATE${NC}"
    
    cd - > /dev/null
}

# 清理舊的構建檔案
clean_build() {
    echo -e "${BLUE}清理舊的構建檔案...${NC}"
    cd "$FLUTTER_PROJECT_DIR"
    
    flutter clean
    flutter pub get
    
    echo -e "${GREEN}✓ 清理完成${NC}"
    cd - > /dev/null
}

# 構建正式版 APK
build_release_apk() {
    echo -e "${BLUE}構建正式版 APK...${NC}"
    cd "$FLUTTER_PROJECT_DIR"
    
    # 使用正式環境 API URL 構建
    flutter build apk \
        --release \
        --dart-define=API_BASE_URL="$PRODUCTION_API_URL" \
        --build-name="$VERSION" \
        --build-number="$(date +%s)"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}錯誤：APK 構建失敗${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ APK 構建成功${NC}"
    cd - > /dev/null
}

# 重命名和移動 APK 檔案
organize_apk() {
    echo -e "${BLUE}組織 APK 檔案...${NC}"
    
    SOURCE_APK="$FLUTTER_PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
    TARGET_APK="${APK_NAME}-v${VERSION}-${COMMIT_HASH}.apk"
    
    if [ ! -f "$SOURCE_APK" ]; then
        echo -e "${RED}錯誤：找不到構建的 APK 檔案${NC}"
        exit 1
    fi
    
    # 創建 releases 目錄
    mkdir -p releases
    
    # 複製並重命名 APK
    cp "$SOURCE_APK" "releases/$TARGET_APK"
    
    # 獲取檔案大小
    APK_SIZE=$(du -h "releases/$TARGET_APK" | cut -f1)
    
    echo -e "${GREEN}✓ APK 檔案已保存: releases/$TARGET_APK${NC}"
    echo -e "${GREEN}檔案大小: $APK_SIZE${NC}"
}

# 創建 Release Notes
create_release_notes() {
    echo -e "${BLUE}創建 Release Notes...${NC}"
    
    RELEASE_NOTES_FILE="releases/release-notes-v${VERSION}.md"
    
    cat > "$RELEASE_NOTES_FILE" << EOF
# AVPlayer v${VERSION} 正式版

## 📱 下載

- **APK 檔案**: ${TARGET_APK}
- **檔案大小**: ${APK_SIZE}
- **API 服務**: ${PRODUCTION_API_URL}

## 🔧 構建資訊

- **版本**: ${VERSION}
- **Commit**: ${COMMIT_HASH}
- **構建時間**: ${BUILD_DATE}
- **Flutter 版本**: $(flutter --version | head -n 1)

## 📋 更新內容

- 使用正式版 API 服務
- 優化播放器功能
- 修復已知問題
- 效能改進

## 🚀 安裝說明

1. 下載 APK 檔案
2. 在 Android 設備上啟用「未知來源安裝」
3. 安裝 APK 檔案

## 📞 問題回報

如有任何問題，請在 [GitHub Issues](https://github.com/${GITHUB_REPO}/issues) 回報。
EOF

    echo -e "${GREEN}✓ Release Notes 已創建: $RELEASE_NOTES_FILE${NC}"
}

# 發布到 GitHub Releases
publish_to_github() {
    if [ "$SKIP_GITHUB_RELEASE" = true ]; then
        echo -e "${YELLOW}跳過 GitHub 發布（GitHub CLI 未安裝）${NC}"
        return
    fi
    
    echo -e "${BLUE}發布到 GitHub Releases...${NC}"
    
    # 檢查是否已登入 GitHub CLI
    if ! gh auth status &> /dev/null; then
        echo -e "${YELLOW}需要登入 GitHub CLI...${NC}"
        gh auth login
    fi
    
    # 創建 Git tag
    TAG_NAME="v${VERSION}"
    git tag -a "$TAG_NAME" -m "Release version $VERSION"
    git push origin "$TAG_NAME"
    
    # 創建 GitHub Release
    gh release create "$TAG_NAME" \
        "releases/$TARGET_APK" \
        --title "AVPlayer v${VERSION}" \
        --notes-file "releases/release-notes-v${VERSION}.md" \
        --latest
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 已成功發布到 GitHub Releases${NC}"
        echo -e "${GREEN}Release URL: https://github.com/${GITHUB_REPO}/releases/tag/${TAG_NAME}${NC}"
    else
        echo -e "${RED}錯誤：GitHub 發布失敗${NC}"
        exit 1
    fi
}

# 顯示摘要
show_summary() {
    echo ""
    echo -e "${GREEN}=== 構建完成 ===${NC}"
    echo -e "${GREEN}APK 檔案: releases/$TARGET_APK${NC}"
    echo -e "${GREEN}Release Notes: releases/release-notes-v${VERSION}.md${NC}"
    echo -e "${GREEN}版本: $VERSION${NC}"
    echo -e "${GREEN}API URL: $PRODUCTION_API_URL${NC}"
    
    if [ "$SKIP_GITHUB_RELEASE" != true ]; then
        echo -e "${GREEN}GitHub Release: https://github.com/${GITHUB_REPO}/releases/tag/v${VERSION}${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}您可以在 releases/ 目錄找到所有構建檔案。${NC}"
}

# 主函數
main() {
    check_requirements
    get_version_info
    clean_build
    build_release_apk
    organize_apk
    create_release_notes
    publish_to_github
    show_summary
}

# 執行主函數
main "$@"
