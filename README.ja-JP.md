<div align="center">
  <img src="LOGO.png" alt="Claude Scholar Logo" width="100%"/>

  <p>
    <a href="https://github.com/Galaxy-Dawn/claude-scholar/stargazers"><img src="https://img.shields.io/github/stars/Galaxy-Dawn/claude-scholar?style=flat-square&color=yellow" alt="Stars"/></a>
    <a href="https://github.com/Galaxy-Dawn/claude-scholar/network/members"><img src="https://img.shields.io/github/forks/Galaxy-Dawn/claude-scholar?style=flat-square" alt="Forks"/></a>
    <img src="https://img.shields.io/github/last-commit/Galaxy-Dawn/claude-scholar?style=flat-square" alt="Last Commit"/>
    <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
    <img src="https://img.shields.io/badge/Claude_Code-Compatible-blueviolet?style=flat-square" alt="Claude Code"/>
    <img src="https://img.shields.io/badge/Codex_CLI-Compatible-blue?style=flat-square" alt="Codex CLI"/>
    <img src="https://img.shields.io/badge/OpenCode-Compatible-orange?style=flat-square" alt="OpenCode"/>
  </p>

  <strong>Language</strong>: <a href="README.md">English</a> | <a href="README.zh-CN.md">中文</a> | <a href="README.ja-JP.md">日本語</a>

</div>

> 学術研究とソフトウェア開発のための半自動リサーチアシスタント。特にコンピュータサイエンスおよびAI研究者向け。[Claude Code](https://github.com/anthropics/claude-code)、[Codex CLI](https://github.com/openai/codex)、[OpenCode](https://github.com/opencode-ai/opencode)をサポートし、文献レビュー、コーディング、実験、レポート作成、論文執筆、プロジェクトナレッジ管理に対応。

  <p><em>ブランチについて</em>: <code>main</code>ブランチはClaude Codeワークフロー用です。Codex CLIをご利用の場合は<a href="https://github.com/Galaxy-Dawn/claude-scholar/tree/codex"><code>codex</code>ブランチ</a>を、OpenCodeをご利用の場合は<a href="https://github.com/Galaxy-Dawn/claude-scholar/tree/opencode"><code>opencode</code>ブランチ</a>をご参照ください。</p>

## 最新ニュース

- **2026-04-22**: **軽量なコア指示へ更新** — 常時読み込まれる大きな `CLAUDE.md` / `AGENTS.md` をコンパクトなコア指示に置き換え、中国語版の補助ファイルを追加し、詳細な skills、commands、agents、作業手順は必要時に読む参照として残しました。これによりデフォルトの context コストを抑えます。
- **2026-04-15**: **pubfig と pubtab という 2 つの Python package を導入** — [`pubfig`](https://github.com/Galaxy-Dawn/pubfig) を論文品質の科学図向け Python package、[`pubtab`](https://github.com/Galaxy-Dawn/pubtab) を出版品質の比較表と Excel↔LaTeX 作業向け Python package として位置づけ、論文図、比較表、書き出し制御、最終確認までの作業経路をより明確にしました。
- **2026-04-15**: **publication-chart-skill を Claude Scholar に統合** — [`pubfig`](https://github.com/Galaxy-Dawn/pubfig) + [`pubtab`](https://github.com/Galaxy-Dawn/pubtab) を `publication-chart-skill` としてまとめてリポジトリに追加し、Claude Scholar の分析・執筆スタックの接続点として位置づけました。これにより、論文品質の図表作業を汎用分析や文章作成用 skill に混ぜず、明示的な受け渡しで扱えるようになりました。

## クイックナビゲーション

| セクション | 内容 |
|---|---|
| [Claude Scholarとは](#claude-scholarとは) | プロジェクトの位置づけとターゲットユースケース |
| [コアワークフロー](#コアワークフロー) | アイデア創出から出版までのエンドツーエンド研究パイプライン |
| [クイックスタート](#クイックスタート) | フル、ミニマル、選択的、プラグインマーケットプレイス経由のインストール |
| [使い始めのシナリオ](#使い始めのシナリオ) | インストール後の代表的な使い始め方を見る |
| [連携ツール](#連携ツール) | ZoteroとObsidianのワークフロー統合 |
| [主要ワークフロー](#主要ワークフロー) | 研究・開発の主要ワークフロー一覧 |
| [サポートワークフロー](#サポートワークフロー) | 主要ワークフローを支えるバックグラウンドシステム |
| [ドキュメント](#ドキュメント) | セットアップ、設定、テンプレートへのリンク |
| [引用](#引用) | 論文やレポートでのClaude Scholarの引用方法 |

## Claude Scholarとは

Claude Scholarは、研究者を置き換えようとするエンドツーエンドの自律研究システムでは**ありません**。

コアとなるアイデアはシンプルです:

> **意思決定の中心は人間に置き、アシスタントはその周辺のワークフローを加速する。**

つまりClaude Scholarは、研究の中で繰り返し発生する重い作業や構造に敏感な作業 — 文献整理、ノートテイキング、実験分析、レポート作成、ライティング支援 — を支援するよう設計されていますが、重要な判断は常に人間の手に委ねられます:

- どの問題が追求に値するか
- どの論文が本当に重要か
- どの仮説をテストすべきか
- どの結果が説得力があるか
- 何を書き、投稿し、あるいは断念すべきか

言い換えれば、Claude Scholarは**半自動リサーチアシスタント**であり、「完全自動化された科学者」ではありません。

## 対象ユーザー

Claude Scholarは特に以下のような方に適しています:

- 文献レビュー、コーディング、実験、論文執筆を行き来する**コンピュータサイエンス研究者**
- アイデア創出、実装、分析、レポート作成、リバッタルまで一つのアシスタントワークフローが必要な**AI/ML研究者**
- 人間の判断を手放さずにワークフローの構造を強化したい**研究エンジニアや大学院生**
- Zotero、Obsidian、CLIオートメーション、再現可能なプロジェクトメモリの恩恵を受ける**ソフトウェア中心の学術プロジェクト**

他の研究分野でも利用できますが、現在のワークフロー設計はコンピュータサイエンス、AI、および隣接する計算研究に最適化されています。

## コアワークフロー

- **アイデア創出**: 漠然としたトピックを具体的な研究課題、研究ギャップ、初期計画に変換
- **文献**: Zoteroコレクションを通じて論文を検索、インポート、整理、読解
- **論文ノート**: 論文を構造化されたリーディングノートと再利用可能な知見に変換
- **ナレッジベース**: `Papers / Knowledge / Experiments / Results / Writing`にわたる永続的な知識をObsidianにルーティング。ラウンドレベルの実験レポートは`Results/Reports/`に保存
- **実験**: 仮説、実験ライン、実行履歴、知見、次のアクションを追跡
- **分析**: `results-analysis`で厳密な統計、科学的図表、分析アーティファクトを生成
- **レポート**: `results-report`で実験後の完全なレポートを作成し、Obsidianに書き戻し
- **執筆と出版**: 安定した知見をレビュー、論文、リバッタル、スライド、ポスター、プロモーションに展開

## クイックスタート

### 前提条件

- [Claude Code](https://github.com/anthropics/claude-code)
- Git
- (任意) Python + [uv](https://docs.astral.sh/uv/) — Python開発用
- (任意) [Zotero](https://www.zotero.org/) + [Galaxy-Dawn/zotero-mcp](https://github.com/Galaxy-Dawn/zotero-mcp) — 文献ワークフロー用
- (任意) [Obsidian](https://obsidian.md/) — プロジェクトナレッジベースワークフロー用

### オプション1: フルインストール（推奨）

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar
bash /tmp/claude-scholar/scripts/setup.sh
```

**Windows**: インストーラーの実行にはGit BashまたはWSLをご使用ください。

インストーラーは**バックアップ対応かつインクリメンタルアップデートに対応**しています:
- リポジトリ管理の`skills/commands/agents/rules/hooks/scripts/CLAUDE*.md`を更新
- 上書きされるファイルを`~/.claude/.claude-scholar-backups/<timestamp>/`にバックアップ
- `settings.json`を`settings.json.bak`にバックアップ
- 既存の`~/.claude/CLAUDE.md`を保持し、リポジトリ版を`~/.claude/CLAUDE.scholar.md`としてインストール
- 既存の`~/.claude/CLAUDE.zh-CN.md`を保持し、リポジトリ版を`~/.claude/CLAUDE.zh-CN.scholar.md`としてインストール
- 既存の`env`、モデル/プロバイダー設定、APIキー、パーミッション、現在の`mcpServers`値を保持
- 既存のフックセットを置き換えるのではなく、不足しているフックエントリを追加

**CLAUDEに関する重要事項**: 既に独自の`~/.claude/CLAUDE.md`や`~/.claude/CLAUDE.zh-CN.md`をお持ちの場合、インストール後に`~/.claude/CLAUDE.scholar.md`と`~/.claude/CLAUDE.zh-CN.scholar.md`を確認し、必要なClaude Scholarのセクションを手動でマージしてください。サイドカーファイルは自動的には適用されません。

アップデート方法:

```bash
cd /tmp/claude-scholar
git pull --ff-only
bash scripts/setup.sh
```

### オプション2: ミニマルインストール

研究にフォーカスした最小限のサブセットのみをインストール:

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar
mkdir -p ~/.claude/hooks ~/.claude/skills
cp /tmp/claude-scholar/hooks/*.js ~/.claude/hooks/
cp -r /tmp/claude-scholar/skills/ml-paper-writing ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/research-ideation ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/results-analysis ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/results-report ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/review-response ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/writing-anti-ai ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/git-workflow ~/.claude/skills/
cp -r /tmp/claude-scholar/skills/bug-detective ~/.claude/skills/
```

**インストール後**: ミニマル/手動インストールでは`settings.json`の自動マージは行われません。`settings.json.template`から必要なhooksやMCPエントリのみをコピーしてください。既に独自の`~/.claude/CLAUDE.md`や`~/.claude/CLAUDE.zh-CN.md`をお持ちの場合は、上書きせずにこのリポジトリのCLAUDEファイルから関連セクションをマージしてください。

### オプション3: 選択的インストール

必要な部分のみをコピー:

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar
cd /tmp/claude-scholar

cp hooks/*.js ~/.claude/hooks/
cp -r skills/latex-conference-template-organizer ~/.claude/skills/
cp -r skills/architecture-design ~/.claude/skills/
cp agents/paper-miner.md ~/.claude/agents/
cp rules/coding-style.md ~/.claude/rules/
cp rules/agents.md ~/.claude/rules/
```

**インストール後**: 選択的/手動インストールでは`settings.json`の自動マージは行われません。`settings.json.template`から実際に必要なhooksやMCPエントリのみをコピーしてください。既に独自の`~/.claude/CLAUDE.md`や`~/.claude/CLAUDE.zh-CN.md`をお持ちの場合は、上書きせずに関連セクションをマージしてください。

### オプション4: プラグインマーケットプレイス経由のインストール

**ステップ1: プラグインをインストール**

```bash
/plugin marketplace add Galaxy-Dawn/claude-scholar
/plugin install claude-scholar@claude-scholar
```

これにより、skills、commands、agents、hooks が自動で読み込まれます。インストール時に、適用範囲として user（全プロジェクト）または project（単一プロジェクト）を選択できます。

**ステップ2: ルールをインストール（必須）**

Claude Code のプラグインは rules を自動配布できないため、手動で追加してください:

```bash
git clone https://github.com/Galaxy-Dawn/claude-scholar.git /tmp/claude-scholar

# ユーザー全体（全プロジェクト）
mkdir -p ~/.claude/rules
cp /tmp/claude-scholar/rules/*.md ~/.claude/rules/

# あるいはプロジェクト単位（現在のプロジェクトのみ）
mkdir -p .claude/rules
cp /tmp/claude-scholar/rules/*.md .claude/rules/
```

**インストール後**: プラグインインストールでは `CLAUDE.md` の自動読み込みや `settings.json` の自動設定は行われません。既に独自の `~/.claude/CLAUDE.md` や `~/.claude/CLAUDE.zh-CN.md` をお持ちの場合は、プラグインが自動適用すると考えず、Claude Scholar 側の関連セクションを手動でマージしてください。Zotero MCP などの連携が必要な場合は、[連携ツール](#連携ツール) セクションを参照してください。

## 使い始めのシナリオ

インストール後は、システム全体を先に覚えようとするよりも、自然言語で今やりたいことをそのまま伝えるのがいちばん簡単です。ここでは、最初の一歩として使いやすい代表的なシナリオをいくつか挙げます。

### 1. 新しい研究テーマを立ち上げる
**たとえばこう言えます:**
> [あなたの研究テーマ]について研究を始めたいです。文献に基づいた初期プラン、重要な未解決問題、次にやるべき具体的なステップを整理してください。

**Claude Scholarがよく支援する内容:**
- テーマを明確化して研究課題を絞り込む
- 優先して見るべき文献の方向を整理する
- 初期計画や仮説候補をまとめる
- 必要ならZoteroやObsidianにも流し込む

### 2. Zotero文献コレクションをレビューする
**たとえばこう言えます:**
> Zoteroにある brain foundation models 関連の文献コレクションをレビューして、主な流れ、研究ギャップ、次に有望な方向をまとめてください。

**典型的な出力:**
- テーマ別の論文整理
- 簡潔な文献総括
- ギャップ分析
- 次に掘る価値のある研究方向

### 3. 完了した実験結果を分析する
**たとえばこう言えます:**
> この実験フォルダの結果を分析して、各runで何が変わったのかを確認し、意思決定に使える要約を書いてください。

**典型的な出力:**
- 指標比較
- アブレーションやエラー分析の提案
- 何が堅い結論で、何がまだ弱く、次に何を走らせるべきかを整理した結果要約

### 4. 論文の節やrebuttal草稿を書く
**たとえばこう言えます:**
> このプロジェクトの現時点の知見と論文メモに基づいて、関連研究の節の草稿を書いてください。

または:

> これらの査読コメントに対するrebuttal草稿を手伝ってください。

**典型的な出力:**
- 構造化された節ドラフト
- より明確な論理展開
- 主張と根拠の対応整理
- 追加で検証や補強が必要な論点

### 実用上のメモ
- 最初は「全部やって」ではなく、具体的な一つのタスクから始めるのがおすすめです。
- すでに自分用のローカル`CLAUDE.md`を運用している場合は、Claude Scholarの必要な内容を手動でマージしてください。別名で配置されたファイルが自動適用されるわけではありません。
- ZoteroとObsidianは必須ではありませんが、単発のチャット出力ではなく、継続的な文献ノートやプロジェクトメモリを残したい場合にはかなり有用です。

## プラットフォームサポート

Claude Scholarは以下のプラットフォームをサポートしています:

- **Claude Code** — 主要なインストール対象
- **Codex CLI** — サポートされたワークフローとドキュメントがこのリポジトリエコシステムで利用可能
- **OpenCode** — 代替CLIワークフローとしてサポート

トップレベルのワークフローは共通: 研究、コーディング、実験、レポート作成、プロジェクトナレッジ管理。

## 連携ツール

### Zotero

以下の用途でClaude ScholarにZoteroを連携できます:
- DOI / arXiv / URLによる論文インポート
- コレクションベースのリーディングワークフロー
- Zotero MCPを通じたフルテキストアクセス
- 詳細な論文ノートと文献合成

詳細は [MCP_SETUP.ja-JP.md](./MCP_SETUP.ja-JP.md) を参照。

### Obsidian

ファイルシステムファーストの研究ナレッジベースとしてObsidianを利用できます:
- `Papers/`
- `Experiments/`
- `Results/`
- `Results/Reports/`
- `Writing/`
- `Daily/`

詳細は [OBSIDIAN_SETUP.ja-JP.md](./OBSIDIAN_SETUP.ja-JP.md) を参照。

## 主要ワークフロー

アイデアから出版まで — 7段階の学術研究ライフサイクル。

### 1. リサーチアイデア創出（Zotero連携）

アイデア生成から文献管理までのエンドツーエンド研究スタートアップ。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `research-ideation` | 漠然としたトピックを構造化された研究課題、ギャップ分析、初期研究計画に変換 |
| Agent | `literature-reviewer` | 論文を検索、分類、合成し、実用的な文献全体像を構築 |
| Command | `/research-init` | 文献検索からZotero整理、提案書草稿まで新トピックを開始 |
| Command | `/zotero-review` | 既存のZoteroコレクションをレビューし、構造化された文献合成を生成 |
| Command | `/zotero-notes` | Zoteroコレクションを一括読解し、構造化された論文リーディングノートを作成 |

**仕組み**
- **5W1Hブレインストーミング**: 漠然としたトピックを構造化された問い（What / Why / Who / When / Where / How）に変換
- **文献検索とインポート**: 論文を検索、DOI/arXiv/URLを抽出、Zoteroにインポートし、テーマ別コレクションに整理
- **PDFとフルテキスト**: 可能な場合はPDFを添付・フルテキストを読解、必要に応じてアブストラクトレベルの分析にフォールバック
- **ギャップ分析**: 文献的、方法論的、応用的、学際的、時間的ギャップを特定
- **研究課題と計画**: レビューを具体的な研究課題、初期仮説、次ステップ計画に変換

**典型的な出力**
- 文献レビューノート
- 構造化されたZoteroコレクション
- プロジェクト提案書 / 研究方向性ドラフト

### 2. MLプロジェクト開発

実験コードとイテレーションのための保守性の高いMLプロジェクト構造。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `architecture-design` | 新しい登録可能なコンポーネントやモジュール導入時に保守性の高いMLプロジェクト構造を定義 |
| Skill | `git-workflow` | ブランチ管理、コミット規約、安全なコラボレーションワークフローを適用 |
| Skill | `bug-detective` | スタックトレース、シェルエラー、コードパスの問題を体系的にデバッグ |
| Agent | `code-reviewer` | 変更されたコードの正確性、保守性、実装品質をレビュー |
| Command | `/plan` | コーディング前に実装計画を作成・改善 |
| Command | `/commit` | 現在の変更に対してConventional Commitを準備 |
| Command | `/code-review` | 現在のコード変更に対するフォーカスレビューを実行 |
| Command | `/tdd` | テスト駆動の小さな実装ステップで機能開発を推進 |

**仕組み**
- **構造**: 適切な場合にFactory / Registryパターンを使用
- **コード品質**: ファイルを保守可能、型付き、設定駆動に維持
- **デバッグ**: スタックトレース、シェルエラー、コードパスの問題を体系的に調査
- **Git規律**: ブランチ管理、Conventional Commits、安全なmerge/rebaseワークフロー

### 3. 実験分析

科学的図表とレポート用アーティファクトを伴う厳密な実験結果分析。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `results-analysis` | 厳密な統計、科学的図表、分析アーティファクトを含む分析バンドルを生成 |
| Skill | `results-report` | 分析アーティファクトを、意思決定、限界、次アクションを含む完全な実験後レポートに変換 |
| Command | `/analyze-results` | 厳密な分析と最終レポート生成をワンショットで実行 |

**仕組み**
- **データ処理**: 実験ログ、メトリクスファイル、結果ディレクトリを読解
- **統計検定**: 適切な場合にt検定 / ANOVA / Wilcoxon等の厳密な統計チェックを実行
- **可視化**: 曖昧なプロット提案ではなく、解釈ガイダンス付きの科学的図表を生成
- **アブレーションと比較**: コンポーネント寄与度、パフォーマンストレードオフ、安定性を分析
- **実験後レポート**: 分析バンドルを結論、限界、次アクションを含む完全な振り返りレポートに変換

**典型的な出力**
- `analysis-report.md`
- `stats-appendix.md`
- `figure-catalog.md`
- `figures/`
- Obsidian `Results/Reports/`内の実験後サマリーレポート

### 4. 論文執筆

構造セットアップからドラフト改善までの体系的な学術ライティング。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `ml-paper-writing` | リポジトリコンテキスト、エビデンス、文献からML/AI論文を執筆 |
| Skill | `citation-verification` | 参考文献、メタデータ、主張と引用の整合性をチェックし引用ミスを防止 |
| Skill | `writing-anti-ai` | 機械的な表現を減らし、明瞭さ、リズム、人間的な学術トーンを改善 |
| Skill | `latex-conference-template-organizer` | 乱雑な学会テンプレートをOverleaf対応のライティング構造に整理 |
| Agent | `paper-miner` | 優れた論文から再利用可能なライティングパターン、構造、学会の期待値を抽出 |
| Command | `/mine-writing-patterns` | 論文を読み込み、再利用可能なライティング知識をグローバルpaper-minerメモリにマージ |

**仕組み**
- **テンプレート準備**: 学会テンプレートをOverleaf対応構造に整理
- **引用検証**: 参考文献、メタデータ、主張と引用の整合性を検証
- **体系的執筆**: リポジトリコンテキスト、実験エビデンス、文献ノートからセクションを執筆
- **スタイル改善**: 機械的な表現を減らし、リズム、明瞭さ、トーンを改善

### 5. 論文セルフレビュー

投稿前の品質保証。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `paper-self-review` | 投稿前に構造、ロジック、引用、図表、コンプライアンスを監査 |

**仕組み**
- **構造チェック**: 論理的な流れ、セクションバランス、物語の一貫性
- **ロジック検証**: 主張とエビデンスの整合性、前提の明確さ、議論の一貫性
- **引用監査**: 参考文献の正確性と完全性
- **図表品質**: キャプションの完全性、可読性、アクセシビリティ
- **コンプライアンス**: ページ制限、フォーマット、開示要件

### 6. 投稿とリバッタル

投稿準備とレビュー対応ワークフロー。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `review-response` | レビューアコメントをエビデンスベースのリバッタルワークフローに構造化 |
| Agent | `rebuttal-writer` | プロフェッショナルで敬意を持った、戦略的に構成されたリバッタルテキストを執筆 |
| Command | `/rebuttal` | レビューコメントとエビデンスから完全なリバッタルドラフトを生成 |

**仕組み**
- **投稿前チェック**: 学会固有のフォーマット、匿名化、チェックリスト要件
- **レビュー分析**: レビューアコメントをアクション可能なカテゴリに分類
- **対応戦略**: 受け入れ、反論、明確化、新実験の提案を判断
- **リバッタル執筆**: プロフェッショナルなトーンで構造化されたエビデンスベースの回答を生成

### 7. アクセプト後処理

アクセプト後の学会準備と研究プロモーション。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `post-acceptance` | アクセプト後の発表、ポスター、研究プロモーションをサポート |
| Command | `/presentation` | アクセプトされた研究の発表構成とスピーキングガイダンスを生成 |
| Command | `/poster` | 研究内容をポスター用コンテンツとレイアウトガイダンスに整理 |
| Command | `/promote` | サマリー、投稿、スレッドなどの外部向けプロモーションコンテンツを作成 |

**仕組み**
- **プレゼンテーション**: 発表構成とスライドガイダンスを準備
- **ポスター**: コンテンツをポスター用レイアウトと階層に整理
- **プロモーション**: ソーシャルメディア、ブログ、サマリー素材を生成

## サポートワークフロー

主要ワークフローを強化するバックグラウンドワークフロー。

### Obsidianプロジェクトナレッジベース

Obsidianを単なるノートダンプではなく、プロジェクト知識の永続的なシンクとして使用。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `obsidian-project-memory` | プロジェクトレベルのObsidianナレッジベースを維持し、書き戻すべき永続的知識を判断 |
| Skill | `obsidian-project-bootstrap` | 新規または既存の研究プロジェクト用にObsidianナレッジベースを初期化 |
| Skill | `obsidian-research-log` | 日々の研究進捗、計画、アイデア、TODOをナレッジベースに記録 |
| Skill | `obsidian-experiment-log` | 実験セットアップ、実行履歴、結果、フォローアップアクションをObsidianに記録 |
| Command | `/obsidian-ingest` | 新しいMarkdownファイルやフォルダをナレッジベースの適切な場所に取り込み |
| Command | `/obsidian-note` | 検索、リネーム、アーカイブ、パージなど単一ノートのライフサイクルを管理 |
| Command | `/obsidian-views` | `.base`ファイルなどのオプショナルObsidianビューを生成・更新 |

**仕組み**
- 既存リポジトリをObsidian Vaultにバインド
- `Papers / Knowledge / Experiments / Results / Writing`に安定した知識をルーティング（ラウンドレベル実験レポートは`Results/Reports/`に保存）
- `Daily/`とプロジェクトメモリを保守的に更新
- 新しいMarkdownファイルを正しい正規の保存先に取り込み
- オプションで追加のビューやキャンバスを生成

**ノート言語設定**

生成・同期されるObsidianノートの言語は以下の優先順位で決定:
1. プロジェクト設定: `.claude/project-memory/registry.yaml` -> `note_language`
2. 環境変数: `OBSIDIAN_NOTE_LANGUAGE`
3. デフォルト: `en`

注: ファイルは歴史的な理由で`registry.yaml`という名前ですが、実際のフォーマットはJSONです。

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

英語と中国語のセクション見出しは同期時に相互互換性があるため、言語設定を切り替えた後でもどちらの言語の既存ノートも安全に更新できます。

### 自動化ワークフロー

クロスプラットフォームフックによるルーティンワークフローチェックとリマインダーの自動化。

**Hooks**
- `skill-forced-eval.js`
- `session-start.js`
- `session-summary.js`
- `stop-summary.js`
- `security-guard.js`

**仕組み**
- **プロンプト前**: 適用可能なスキルを評価し、関連するワークフローヒントを表示
- **セッション開始時**: Git状態、利用可能なコマンド、プロジェクトメモリコンテキストを表示
- **セッション終了/停止時**: 作業を要約し、最低限のメンテナンスタスクをリマインド
- **セキュリティ**: 壊滅的なコマンドをブロックし、危険だが正当なコマンドには確認を要求

### 知識抽出ワークフロー

専門エージェントが論文やコンペティションから再利用可能な知識をマイニング。

| 種類 | 名前 | 概要 |
|---|---|---|
| Agent | `paper-miner` | 優れた論文から再利用可能なライティング知識、構造パターン、学会ヒューリスティクスを抽出 |
| Agent | `kaggle-miner` | 優れたKaggleワークフローからエンジニアリングプラクティスとソリューションパターンを抽出 |

**仕組み**
- 論文からライティングパターン、学会の期待値、リバッタル戦略を抽出
- Kaggleワークフローからエンジニアリングパターンとソリューション構造を抽出
- これらの知見をスキルや参考資料にフィードバック

### スキル進化システム

Claude Scholar自身のスキルに対する自己改善ループ。

| 種類 | 名前 | 概要 |
|---|---|---|
| Skill | `skill-development` | 明確なトリガー、構造、段階的開示を持つ新スキルを作成 |
| Skill | `skill-quality-reviewer` | コンテンツ品質、構成、スタイル、構造的完全性にわたってスキルをレビュー |
| Skill | `skill-improver` | 構造化された改善計画を適用して既存スキルを進化 |

**仕組み**
- 明確なトリガー説明を持つ新スキルを作成
- 品質の各次元にわたってレビュー
- 構造化された改善を適用し、イテレーション

## ドキュメント

- [MCP_SETUP.ja-JP.md](./MCP_SETUP.ja-JP.md) — Zotero/ブラウザMCPセットアップ（日本語）
- [OBSIDIAN_SETUP.ja-JP.md](./OBSIDIAN_SETUP.ja-JP.md) — Obsidianナレッジベースワークフロー（日本語）
- [CLAUDE.ja-JP.md](./CLAUDE.ja-JP.md) — 軽量な Claude Code コア指示の日本語版
- [CLAUDE.md](./CLAUDE.md) — 軽量な Claude Code コア指示（英語版）
- [CLAUDE.zh-CN.md](./CLAUDE.zh-CN.md) — 軽量コア指示の中国語版補助ファイル
- [settings.json.template](./settings.json.template) — hooks/plugins/MCP用のオプション設定テンプレート

## プロジェクトルール

Claude Scholarには以下のプロジェクトルールが含まれています:
- コーディングスタイル
- エージェントオーケストレーション
- セキュリティ
- 実験再現性

これらはシッピングされたルールと`CLAUDE.md`に反映されています。

## コントリビューション

Issue、PR、ワークフローの改善を歓迎します。

インストーラーの動作、Zoteroワークフロー、Obsidianルーティングへの変更を提案する場合は、以下を含めてください:
- ユーザーシナリオ
- 現在の制限事項
- 期待される動作
- 互換性に関する懸念事項

## ライセンス

MIT License。

## 引用

Claude Scholarがあなたの研究やエンジニアリングワークフローに役立った場合、以下のようにリポジトリを引用できます:

```bibtex
@misc{claude_scholar_2026,
  title        = {Claude Scholar: Semi-automated research assistant for academic research and software development},
  author       = {Gaorui Zhang},
  year         = {2026},
  howpublished = {\url{https://github.com/Galaxy-Dawn/claude-scholar}},
  note         = {GitHub repository}
}
```

## 謝辞

Claude Code CLIで構築され、オープンソースコミュニティによって強化されています。

### 参考プロジェクト

本プロジェクトは、コミュニティの優れた成果からインスピレーションを受け、それらを基盤としています:

- **[everything-claude-code](https://github.com/anthropics/everything-claude-code)** - Claude Code CLIの包括的なリソース
- **[AI-research-SKILLs](https://github.com/zechenzhangAGI/AI-research-SKILLs)** - 研究に特化したスキルと設定

これらのプロジェクトは、Claude Scholarの研究指向機能に貴重な知見と基盤を提供しました。

---

**データサイエンス、AI研究、学術ライティングのために。**

リポジトリ: [https://github.com/Galaxy-Dawn/claude-scholar](https://github.com/Galaxy-Dawn/claude-scholar)
