# プロジェクトへの貢献ガイド

「つなぐ」プロジェクトへの貢献に興味を持っていただき、ありがとうございます！このガイドでは、プロジェクトに貢献する方法について説明します。

## 貢献の種類

以下のような形でプロジェクトに貢献できます：

- 🐛 バグレポート
- 💡 新機能の提案
- 📝 ドキュメントの改善
- 🔧 コードの修正・改善
- 🧪 テストの追加・改善
- 🎨 UI/UXの改善

## 始める前に

1. [行動規範](CODE_OF_CONDUCT.md) を読んで理解してください
2. 既存の [Issues](https://github.com/tenpei-peso/tunagu/issues) を確認して、重複を避けてください
3. [ディスカッション](https://github.com/tenpei-peso/tunagu/discussions) で事前に相談することをお勧めします

## 開発環境のセットアップ

### 必要な環境

- Flutter SDK 3.13.0 以上
- Dart SDK 3.1.0 以上
- Git
- IDE (Android Studio, VS Code, IntelliJ IDEA など)

### セットアップ手順

1. リポジトリをフォーク:
```bash
# GitHub でフォークボタンをクリック
```

2. ローカルにクローン:
```bash
git clone https://github.com/your-username/tunagu.git
cd tunagu
```

3. 上流リポジトリを追加:
```bash
git remote add upstream https://github.com/tenpei-peso/tunagu.git
```

4. 依存関係をインストール:
```bash
flutter pub get
```

5. 動作確認:
```bash
flutter analyze
flutter test
flutter run
```

## 開発ワークフロー

### ブランチ戦略

- `main`: 本番環境用の安定版
- `develop`: 開発用ブランチ
- `feature/*`: 新機能開発用
- `bugfix/*`: バグ修正用
- `hotfix/*`: 緊急修正用

### 作業手順

1. 最新の変更を取得:
```bash
git checkout develop
git pull upstream develop
```

2. 新しいブランチを作成:
```bash
git checkout -b feature/your-feature-name
```

3. 変更を実装:
   - コーディング
   - テストの追加・修正
   - ドキュメントの更新

4. コードのチェック:
```bash
flutter analyze
dart format .
flutter test
```

5. コミット:
```bash
git add .
git commit -m "feat: 新機能の説明"
```

6. プッシュ:
```bash
git push origin feature/your-feature-name
```

7. プルリクエストを作成

## コーディング規約

### Dart/Flutter 規約

- [Effective Dart](https://dart.dev/guides/language/effective-dart) に従ってください
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) を参考にしてください
- `flutter analyze` でエラーが出ないようにしてください
- `dart format .` でコードをフォーマットしてください

### コミットメッセージ

[Conventional Commits](https://www.conventionalcommits.org/) 形式を使用してください：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Type の種類

- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `style`: コードの意味に影響しない変更（空白、フォーマット等）
- `refactor`: バグ修正でも新機能でもないコード変更
- `perf`: パフォーマンス向上のための変更
- `test`: テストの追加や既存テストの修正
- `chore`: ビルドプロセスやツール・ライブラリの変更

#### 例

```bash
feat(auth): ユーザー認証機能を追加
fix(ui): ボタンの表示位置を修正
docs(readme): インストール手順を更新
```

## テスト

### テストの種類

1. **単体テスト**: ビジネスロジックのテスト
2. **ウィジェットテスト**: UI コンポーネントのテスト
3. **統合テスト**: アプリ全体の動作テスト

### テストの実行

```bash
# 全てのテストを実行
flutter test

# カバレッジレポートを生成
flutter test --coverage

# 特定のテストファイルを実行
flutter test test/widget_test.dart
```

### テストの書き方

- テストは `test/` ディレクトリに配置
- ファイル名は `*_test.dart` の形式
- 日本語での説明を推奨
- 適切なアサーションを使用

```dart
testWidgets('カウンターのインクリメントテスト', (WidgetTester tester) async {
  // アプリをビルド
  await tester.pumpWidget(const MyApp());

  // 初期状態を確認
  expect(find.text('0'), findsOneWidget);

  // ボタンをタップ
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  // 結果を確認
  expect(find.text('1'), findsOneWidget);
});
```

## プルリクエスト

### プルリクエスト作成前のチェックリスト

- [ ] 最新の `develop` ブランチから作業している
- [ ] コーディング規約に従っている
- [ ] テストが通る
- [ ] 適切なテストを追加している
- [ ] ドキュメントを更新している（必要な場合）
- [ ] プルリクエストテンプレートに従って記述している

### レビュープロセス

1. プルリクエストが作成されると、CI が自動実行されます
2. メンテナーがコードレビューを行います
3. 必要に応じて修正を依頼します
4. レビューが完了すると、マージされます

## ドキュメント

### ドキュメントの種類

- README.md: プロジェクトの概要
- API ドキュメント: コード内のコメント
- Wiki: 詳細なガイド
- コメント: コード内の説明

### ドキュメントの書き方

- 日本語で記述
- 明確で理解しやすい表現
- 適切な例を含める
- 最新の状態を保つ

## 質問・相談

何か質問や相談がある場合は、以下の方法でお気軽にお問い合わせください：

- [Issues](https://github.com/tenpei-peso/tunagu/issues): バグ報告・機能リクエスト
- [Discussions](https://github.com/tenpei-peso/tunagu/discussions): 一般的な質問・議論
- [Discord](https://discord.gg/your-server): リアルタイムなコミュニケーション（今後設定予定）

## 謝辞

このプロジェクトに貢献していただき、ありがとうございます！あなたの貢献により、「つなぐ」がより良いプロジェクトになります。

---

Happy coding! 🚀