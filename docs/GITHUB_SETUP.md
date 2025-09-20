# GitHub リポジトリ設定ガイド

このドキュメントでは、「つなぐ」プロジェクトに推奨される GitHub リポジトリの設定について説明します。

## リポジトリ基本設定

### General Settings

1. **Description（説明）**: 
   ```
   つなぐ - Flutter で開発されたモバイルアプリケーション。人と人、サービスとサービスを繋げるプラットフォーム。
   ```

2. **Website**: 
   ```
   https://tenpei-peso.github.io/tunagu
   ```

3. **Topics（トピック）**:
   ```
   flutter, dart, mobile-app, cross-platform, japanese, android, ios, web
   ```

4. **Features**:
   - ✅ Wikis
   - ✅ Issues
   - ✅ Sponsorships
   - ✅ Projects
   - ✅ Discussions

## ブランチ保護ルール

### Main ブランチ保護設定

```yaml
branch_protection_rules:
  main:
    required_status_checks:
      strict: true
      contexts:
        - "コード解析"
        - "テスト実行"
        - "Android ビルド"
        - "Web ビルド"
    enforce_admins: true
    required_pull_request_reviews:
      required_approving_review_count: 1
      dismiss_stale_reviews: true
      require_code_owner_reviews: true
      restrict_dismissals: false
    restrictions: null
    allow_force_pushes: false
    allow_deletions: false
    require_linear_history: true
    required_conversation_resolution: true
```

### Develop ブランチ保護設定

```yaml
branch_protection_rules:
  develop:
    required_status_checks:
      strict: true
      contexts:
        - "コード解析"
        - "テスト実行"
    enforce_admins: false
    required_pull_request_reviews:
      required_approving_review_count: 1
      dismiss_stale_reviews: true
      require_code_owner_reviews: false
      restrict_dismissals: false
    restrictions: null
    allow_force_pushes: false
    allow_deletions: false
    require_linear_history: false
    required_conversation_resolution: true
```

## セキュリティ設定

### Security Alerts

1. **Dependabot alerts**: ✅ 有効
2. **Dependabot security updates**: ✅ 有効
3. **Dependabot version updates**: ✅ 有効（.github/dependabot.yml で設定）

### Code Scanning

1. **CodeQL analysis**: ✅ 有効（.github/workflows/security.yml で設定）
2. **Secret scanning**: ✅ 有効
3. **Push protection**: ✅ 有効

### Private vulnerability reporting

✅ 有効にして、脆弱性の報告を受け付ける

## ラベル設定

### デフォルトラベル（削除推奨）

以下の不要なデフォルトラベルを削除:
- `wontfix`
- `invalid`
- `duplicate`

### 推奨ラベル設定

```yaml
labels:
  # 種類
  - name: "bug"
    color: "d73a4a"
    description: "バグまたは予期しない動作"
  
  - name: "enhancement"
    color: "a2eeef"
    description: "新機能や改善の提案"
  
  - name: "question"
    color: "d876e3"
    description: "質問やサポートが必要"
  
  - name: "documentation"
    color: "0075ca"
    description: "ドキュメントの改善が必要"
  
  # 優先度
  - name: "priority: high"
    color: "b60205"
    description: "高優先度"
  
  - name: "priority: medium"
    color: "fbca04"
    description: "中優先度"
  
  - name: "priority: low"
    color: "0e8a16"
    description: "低優先度"
  
  # サイズ
  - name: "size: XS"
    color: "3cbf00"
    description: "非常に小さな変更（1-2時間）"
  
  - name: "size: S"
    color: "5ebf00"
    description: "小さな変更（半日）"
  
  - name: "size: M"
    color: "7fbf00"
    description: "中程度の変更（1-2日）"
  
  - name: "size: L"
    color: "a0bf00"
    description: "大きな変更（3-5日）"
  
  - name: "size: XL"
    color: "c1bf00"
    description: "非常に大きな変更（1週間以上）"
  
  # 状態
  - name: "status: blocked"
    color: "000000"
    description: "他の作業の完了を待っている"
  
  - name: "status: ready"
    color: "0e8a16"
    description: "作業を開始する準備ができている"
  
  - name: "status: in progress"
    color: "fbca04"
    description: "現在作業中"
  
  - name: "status: review needed"
    color: "ff9500"
    description: "レビューが必要"
  
  # プラットフォーム
  - name: "platform: android"
    color: "3ddc84"
    description: "Android プラットフォーム関連"
  
  - name: "platform: ios"
    color: "007aff"
    description: "iOS プラットフォーム関連"
  
  - name: "platform: web"
    color: "ff6b35"
    description: "Web プラットフォーム関連"
  
  # 分野
  - name: "area: ui"
    color: "f9d0c4"
    description: "ユーザーインターフェース関連"
  
  - name: "area: performance"
    color: "d4c5f9"
    description: "パフォーマンス関連"
  
  - name: "area: testing"
    color: "c5f9d0"
    description: "テスト関連"
  
  - name: "area: ci/cd"
    color: "fef2c0"
    description: "CI/CD パイプライン関連"
  
  # 自動化
  - name: "dependencies"
    color: "0366d6"
    description: "依存関係の更新"
  
  - name: "自動更新"
    color: "0366d6"
    description: "自動的に作成された更新"
  
  - name: "github-actions"
    color: "2188ff"
    description: "GitHub Actions 関連"
  
  # 特別
  - name: "good first issue"
    color: "7057ff"
    description: "初心者におすすめの Issue"
  
  - name: "help wanted"
    color: "008672"
    description: "コミュニティからの支援を求める"
  
  - name: "needs design"
    color: "ff69b4"
    description: "デザインが必要"
  
  - name: "needs discussion"
    color: "d876e3"
    description: "議論が必要"
  
  - name: "需要調査"
    color: "ededed"
    description: "需要やフィードバックの調査が必要"
```

## Environments 設定

### Production Environment

```yaml
environments:
  production:
    protection_rules:
      - type: required_reviewers
        reviewers:
          - tenpei-peso
      - type: wait_timer
        minutes: 5
    deployment_branch_policy:
      protected_branches: true
      custom_branch_policies: false
```

### Staging Environment

```yaml
environments:
  staging:
    protection_rules:
      - type: required_reviewers
        reviewers:
          - tenpei-peso
    deployment_branch_policy:
      protected_branches: false
      custom_branch_policies: true
      custom_branches:
        - develop
        - feature/*
```

## GitHub Pages 設定

1. **Source**: GitHub Actions
2. **Custom domain**: `tunagu.example.com`（ドメインがある場合）
3. **Enforce HTTPS**: ✅ 有効

## 通知設定

### Webhooks（必要に応じて設定）

- Discord webhook（コミュニティ用）
- Slack webhook（チーム用）

### Actions 設定

1. **Fork pull request workflows**: `Require approval for first-time contributors`
2. **Fork pull request workflows in private repositories**: `Require approval for all outside collaborators`

## Issue Templates の有効化

- カスタム Issue テンプレートが既に設定済み
- `blank_issues_enabled: false` でブランク Issue を無効化

## 実装手順

これらの設定は GitHub の Web インターフェースから手動で設定する必要があります：

1. **リポジトリ設定**: `Settings` タブから基本設定を変更
2. **ブランチ保護**: `Settings > Branches` から設定
3. **セキュリティ**: `Settings > Security & analysis` から有効化
4. **ラベル**: `Issues > Labels` から設定
5. **Environments**: `Settings > Environments` から作成
6. **GitHub Pages**: `Settings > Pages` から設定

## 参考リンク

- [GitHub Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [GitHub Security Features](https://docs.github.com/en/code-security)
- [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)