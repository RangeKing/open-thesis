# Obsidianプロジェクトナレッジベース セットアップ

Claude Scholarには、Obsidian研究ナレッジベースワークフローが内蔵されています。MCPやAPIキーは**不要**です。

## 提供される機能

Obsidianは単なる論文ライブラリではなく、研究プロジェクトのデフォルトナレッジベースとして扱われます。プロジェクトナレッジベースには以下を保存できます:

- 安定したプロジェクト背景と研究課題
- 論文ノートと文献合成
- 実験ランブックと結果サマリー
- デイリーリサーチログ、スクラッチノート、同期キュー
- ドラフト、スライド、提案書、リバッタル素材などのライティングアセット
- メインの作業面に残すべきでないアーカイブ済みプロジェクト知識

## 要件

### 必須
- ローカルのObsidian Vaultパス
- 環境変数に`OBSIDIAN_VAULT_PATH`を設定、またはプロジェクトブートストラップ時に明示的に指定

### 任意
- ナビゲーション用にObsidian Desktopをインストールして開いておく
- open/search/dailyアクション用に`obsidian` CLIが利用可能
- よりクリーンな`obsidian://`リンクとCLIターゲティングのための`OBSIDIAN_VAULT_NAME`

## 内蔵スキル

Claude Scholar には project-scoped な Obsidian KB workflow が含まれています。

デフォルトワークフローで最も関連性の高いスキル:

- `obsidian-project-kb-core`
- `obsidian-source-ingestion`
- `obsidian-literature-workflow`
- `obsidian-kb-artifacts`
- `defuddle`

一部のグラフ指向ヘルパーがリポジトリに残っている場合がありますが、デフォルトワークフローは`.base`、MCP、APIサービスに**依存しません**。メインのデフォルトグラフアーティファクトは`Maps/literature.canvas`です。追加の`.base`ビューやプロジェクト/実験キャンバスは明示的な操作でのみ生成されます。

## デフォルトの動作

Claude Scholarが`.claude/project-memory/registry.yaml`を含むリポジトリ内で実行されている場合、そのリポジトリをObsidianプロジェクトナレッジベースにバインド済みとして扱い、デフォルトで更新を行います。

リポジトリがまだバインドされていないが、研究プロジェクトのように見える場合（例えば`.git`、`README.md`、`docs/`、`notes/`、`plan/`、`results/`、`outputs/`、`src/`、または`scripts/`を含む場合）、Claude Scholarは自動的にプロジェクトナレッジベースをブートストラップします。

## Vault内のプロジェクト構造

```text
Research/{project-slug}/
  00-Hub.md
  01-Plan.md
  02-Index.md
  Sources/
  Knowledge/
  Experiments/
  Results/
    Reports/
  Writing/
  Daily/
  Maps/
  Archive/
  _system/
```

一般的に生成される主要ファイル:

- `02-Index.md`
- `_system/registry.md`
- `_system/schema.md`
- `_system/lint-report.md`
- `.claude/project-memory/<project_id>.md`
- `Maps/literature.canvas` when literature workflow needs it

## リポジトリローカルのメモリバインディング

各研究リポジトリは以下にローカルバインディングを持ちます:

```text
.claude/project-memory/
  registry.yaml
  <project_id>.md
```

- `registry.yaml`はリポジトリ↔Vaultのバインディングを保存
- `<project_id>.md`はインクリメンタル同期用のアシスタント向けプロジェクトメモリを保存

## ノート言語

生成・同期されるノートの言語は以下の優先順位で決定されます:
1. `.claude/project-memory/registry.yaml`のプロジェクト設定
2. 環境変数`OBSIDIAN_NOTE_LANGUAGE`
3. デフォルト`en`

注: `registry.yaml` は引き続き repo-local のランタイムバインディング用ファイルであり、project 内の可視な source of truth は `_system/registry.md` です。

サポートされる値:
- `en`
- `zh-CN`

プロジェクトごとの設定例:

```json
{
  "projects": {
    "my-project": {
      "project_id": "my-project",
      "vault_root": "/path/to/vault/Research/my-project",
      "note_language": "zh-CN"
    }
  }
}
```

既存の英語と中国語の見出しは同期時に互換性があるため、設定言語を変更しても既存のノートは壊れません。

## 主要コマンド

- `/kb-init` — vault-first のプロジェクトKBを初期化
- `/kb-status` — バインド済みKBの状態を要約
- `/kb-ingest` — 新しい source material を canonical note にルーティング
- `/kb-log` — 当日の `Daily/` と関連サーフェスを更新
- `/kb-sync` — 決定論的な KB メンテナンスと再同期を実行
- `/kb-links` — canonical notes 間の wikilink を修復または強化
- `/kb-promote` — 安定した内容を canonical note に昇格
- `/kb-index` — `02-Index.md` を再生成
- `/kb-lint` — 決定論的なKB健全性チェックを実行し `_system/lint-report.md` を更新
- `/kb-archive` — KBオブジェクトを archive、detach、purge、rename する
- `/kb-map` — 既定の literature canvas 以外の artifact を明示要求時に生成
- `/kb-literature-review` — `Sources/Papers` から文献統合を作成し `Knowledge`、`Writing`、`Maps/literature.canvas` に書き戻す

## バインド済みリポジトリの最低限のメンテナンス

リポジトリが`.claude/project-memory/registry.yaml`を通じて既にバインドされている場合、Claude Scholarは自動メンテナンスを控えめに行います:

- ターンが研究状態を変更した場合、常に`Daily/YYYY-MM-DD.md`を確認
- `00-Hub.md`はトップレベルのプロジェクトステータスが実際に変わった場合にのみ更新
- プロジェクト状態が変わるたびに`.claude/project-memory/<project_id>.md`を更新
- `Knowledge/`、`Experiments/`、`Results/`、`Writing/`はエージェントファーストとし、毎ターン自動的に書き換えない

## オプション: Obsidian CLIのインストール

公式Obsidian CLIは新しいデスクトップインストーラーに内蔵されています。`obsidian ...`コマンドを使用するには:

1. CLI登録をサポートするObsidian Desktopビルドを使用
2. Obsidian Desktopで`Settings -> General -> Advanced`を開く
3. **Command line interface**を有効にする
4. macOSでは`/Applications/Obsidian.app/Contents/MacOS`が`PATH`に含まれていることを確認（例: `~/.zprofile`で設定）
5. ターミナルを再起動し、確認:

```bash
obsidian help
obsidian search query="diffusion" limit=5
```

`Command line interface is not enabled`と表示される場合、シェルパスは正しいがObsidianアプリ内のトグルがまだオフです。

## ライフサイクルアクション

### デタッチ
- 自動同期を停止
- Vaultコンテンツを保持
- プロジェクトメモリファイルを保持

### アーカイブ（「このプロジェクトの知識を削除」のデフォルト）
- プロジェクトを`Archive/`配下に移動
- 同期を無効化
- 将来の再アクティベーション用にプロジェクトメモリを保持

### パージ
- バインディング、プロジェクトメモリ、Vaultプロジェクトフォルダを完全に削除
- ユーザーが明示的に永久削除を求めた場合にのみ使用

## オプション: CLIとURIの使用

Claude Scholarはオプションで公式Obsidian CLIとURIスキームを使用できます:

- CLIドキュメント: <https://help.obsidian.md/cli>
- URIドキュメント: <https://help.obsidian.md/uri>

例:

```bash
obsidian help
obsidian search query="diffusion" limit=10
obsidian daily:append content="- [ ] Follow up on experiment"
```

```text
obsidian://open?vault=My%20Vault&file=Research%2Fproject-slug%2F00-Hub
obsidian://search?vault=My%20Vault&query=%23experiment
```

## トラブルシューティング

| 問題 | 解決方法 |
|------|---------|
| Vaultパスが見つからずブートストラップが失敗 | `OBSIDIAN_VAULT_PATH`を設定するか、Vaultパスを明示的に指定 |
| プロジェクトが再インポートされ続ける | `.claude/project-memory/registry.yaml`が存在し、正しいリポジトリルートを指しているか確認 |
| Vaultにまだ`Views/`、`Concepts/`、`Datasets/`がデフォルトとして表示される | それらは古いドキュメントや古いプロジェクト生成によるもの。現在のデフォルトワークフローは上記のコンパクト構造を使用し、デフォルトでは`Maps/literature.canvas`のみを保持 |
| CLIコマンドが失敗する | `Settings -> General -> Advanced -> Command line interface`が有効か確認。そうでなければファイルシステムのみの同期を継続 |
| 「プロジェクト知識を削除」が破壊的すぎる | アーカイブまたはデタッチを使用。パージは永久削除専用 |

## WSL → Windowsミラーワークフロー

Claude ScholarをWSL内で実行しながら、より安定したウィンドウ動作のためにネイティブWindowsでObsidianを開きたい場合は、2コピーセットアップを使用します:

- WSL Vaultを信頼できるソースとして維持（例: `<repo-root>/obsidian-vault`）
- WSLにマウントされたWindows側ローカルミラーディレクトリを維持（例: `<wsl-mounted-windows-vault-path>`）
- ミラーされたWindows側ローカルディレクトリをWindows Obsidianで開く

同期方法:

```bash
bash scripts/sync_obsidian_to_windows.sh \
  --windows-path <wsl-mounted-windows-vault-path>
```

必要に応じてプレビュー:

```bash
bash scripts/sync_obsidian_to_windows.sh \
  --windows-path <wsl-mounted-windows-vault-path> \
  --dry-run
```

デフォルトでは、WSLソースに存在しなくなったミラー側のみのファイルは削除されます。Windowsミラーに追加ファイルを残したい場合は`--no-delete`を追加してください。
