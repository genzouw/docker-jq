# AGENTS.md — AI コーディングエージェント向けポリシー

本ドキュメントは、自律型コーディングエージェント (Jules / Devin / Codex / Claude Code / GitHub Copilot / Cursor / Cline / Windsurf / Aider / Sweep / PR-Agent 等) が、公開 OSS リポジトリ [`genzouw/docker-jq`](https://github.com/genzouw/docker-jq) で作業し Pull Request を作成するときに **必ず守るべき規範** を定義します。
キーワードの解釈は [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt) ([日本語訳](https://www.nic.ad.jp/ja/tech/ipa/RFC2119JA.html)) に従います (MUST / MUST NOT / SHOULD / SHOULD NOT / MAY)。

このファイルは [agents.md 規格](https://agents.md/) に従って配置しています。Jules や Codex などの主要エージェントは、このファイルをリポジトリルートから自動的に読み込みます。

---

## 1. 最重要原則: 公開 OSS で完全無料の SaaS・AI・ツールのみを利用する

本リポジトリの CI/CD および自動化ワークフローでは、**公開 OSS リポジトリ向けに「完全無料で利用可能」な SaaS / AI / ツールのみ** を利用します。
「完全無料」の定義は、以下のすべてを満たすことです。

1. 公開 OSS リポジトリ (パブリックな GitHub リポジトリ) で利用する場合に、課金が一切発生しないこと
2. 利用にあたって従量課金 API キー / トークンを必要としないこと
3. 利用量・レート制限・期間制限を超えた瞬間に課金が始まる "無料枠" 型でないこと
4. 有料プラン / 有料ライセンス / 有料トライアル / シート課金 / クレジットカード登録を必要としないこと

上記をひとつでも満たさないサービスを組み込む PR は **MUST NOT** で、提出された場合は内容の良し悪しにかかわらずクローズ対象とします。
このうち構文的に判定できる違反は CI (`free-policy` チェック) が自動検出します。検出する範囲としない範囲は [1.5 CI による自動検出範囲](#15-ci-による自動検出範囲) を参照してください。

### 1.1 MUST NOT — これらを含む PR は問答無用でクローズ対象とします

- **MUST NOT**: LLM プロバイダの API キー / トークンを GitHub Secrets に登録し、CI ワークフロー / GitHub Action から呼び出す構成の追加。
  - 該当する API キー例 (これらに限らない):
    - `GEMINI_API_KEY`, `GOOGLE_API_KEY`, `GOOGLE_GENERATIVE_AI_API_KEY`
    - `OPENAI_API_KEY`, `OPENAI_API_BASE_URL`
    - `ANTHROPIC_API_KEY`, `CLAUDE_API_KEY`, `CLAUDE_CODE_OAUTH_TOKEN`
    - `MISTRAL_API_KEY`, `COHERE_API_KEY`, `GROQ_API_KEY`
    - `DEEPSEEK_API_KEY`, `PERPLEXITY_API_KEY`, `XAI_API_KEY`, `TOGETHER_API_KEY`
    - `HUGGINGFACE_API_TOKEN` (推論 API として使う場合)
  - **「無料枠内に収まる前提」での利用も MUST NOT です**。レート制限到達時に課金が始まる構造そのものを禁止しています。
  - **OpenAI 互換エンドポイント経由 (`OPENAI_API_BASE_URL` を Gemini や DeepSeek 等に向けるパターン) も同じく MUST NOT** です。鍵の名称ではなく「課金可能な API へ繋がる鍵を登録する行為」を禁止しています。
- **MUST NOT**: 従量課金の外部 API キーを要する検索・スクレイピング系サービスの CI 組み込み (`TAVILY_API_KEY`, `EXA_API_KEY`, `SERPAPI_KEY`, `BRAVE_API_KEY` 等)。
- **MUST NOT**: 有料プラン / 有料ライセンス / 有料トライアル / クレジットカード登録を必要とするサービスの CI 組み込み。
- **MUST NOT**: 公開 OSS リポジトリでも Pro プラン以上を要求する SaaS の追加。
- **MUST NOT**: リポジトリオーナーに新規 Secret の発行・登録を依頼する PR (OIDC / 公開鍵証明を用いず、人手で鍵を回す構成のもの)。
- **MUST NOT**: 既存テスト / lint / セキュリティスキャンをスキップ / 無効化 / コメントアウトして提出すること。
- **MUST NOT**: 既に本リポジトリに導入済みのツールと機能が重複する追加 (`.github/workflows/` 配下を必ず事前確認すること)。
- **MUST NOT**: サードパーティ GitHub Action をタグ参照 (`@v1` 等) のみで導入すること。**フルコミット SHA で pin** してください。
- **MUST NOT**: ローカル LLM (Ollama / llama.cpp / LocalAI / vLLM 等) を CI の runner 上で起動し、その推論結果を使う自動化の追加。PR レビュー、Issue トリアージ、アクセシビリティ検査、ドキュメント生成、ハルシネーション検知など、用途を問いません。
  - API キーも課金も不要ですが、それは採用の理由になりません。runner の CPU で動かせる小型モデル (`qwen2.5-coder:0.5b` 等) は出力の質が低く、有害な修正提案を PR に投稿した実例があります ([genzouw/monopo#664](https://github.com/genzouw/monopo/issues/664))。
  - 「完全無料・シークレットレスな AI 自動化」を掲げた [genzouw/toique#961](https://github.com/genzouw/toique/pull/961) は、同種の PR としてクローズ済みです。類似の PR を作成しないでください。
  - モデルや実行方法を差し替えても (別のモデル、別のランタイム、コンテナ実行、self-hosted runner) 同じく MUST NOT です。
  - 禁止しているのは CI/CD および自動化ワークフローへの組み込みです。開発者個人の端末で Ollama 等を動かすことは **MAY** です。

### 1.2 SHOULD — 強く推奨される慣行

- **SHOULD**: 公式 (GitHub / OpenSSF / 主要 OSS 組織) または Verified creator の発行元から提供される GitHub Action / GitHub App を優先する。
- **SHOULD**: ワークフローの `permissions:` は最小権限から始める (`contents: read` を既定とし、必要なジョブで個別に書込権限を付与)。
- **SHOULD**: ワークフローに `concurrency:` を設定し、同一 PR / ref への多重起動を抑止する。
- **SHOULD**: 判断に迷う場合は PR を作らず、Issue でリポジトリオーナー (@genzouw) に相談する。

### 1.3 MAY — 採用してよい構成

- **MAY**: GitHub Marketplace の「公開 OSS リポジトリ向け完全無料プラン」で提供される Action / App。
- **MAY**: GitHub App の「公開 OSS リポジトリ向け完全無料枠」で、API キーの登録が不要なもの (例: CodeRabbit の OSS 無料枠)。
- **MAY**: 完全無料で配布されている GitHub Action (Marketplace 登録の有無は問わない)。
- **MAY**: リポジトリ内で完結するスクリプト / Make ターゲット (外部 SaaS 連携を伴わないもの)。
- **MAY**: 既存ワークフローのキャッシュ最適化、並列化、Action の SHA pin 更新といった、課金を伴わない構造改善。

### 1.4 ローカル環境と CI の区別

本ポリシーが禁止しているのは **CI/CD および自動化ワークフローへの組み込み** です。
開発者個人のローカル環境で、自分のアカウント・自分の負担で AI ツール (Claude Code / Cursor / Antigravity CLI（agy）等) を使うことは **MAY** です。

`ANTHROPIC_API_KEY` / `GEMINI_API_KEY` などを自分のシェルの環境変数として `export` して使うことは **MAY** です。
一方、同じ鍵を GitHub Secrets へ登録し CI から参照することは **MUST NOT** です。

### 1.5 CI による自動検出範囲

`.github/workflows/free-policy.yml` (実体は [`genzouw/ci-workflows`](https://github.com/genzouw/ci-workflows) の reusable workflow) が、本ポリシーのうち構文的に判定できる違反を検出します。走査対象は次のファイルです。

- `.github/` 配下の YAML / JSON (`*.yml` / `*.yaml` / `*.json` / `*.json5`)
- リポジトリルート直下の Renovate 設定 (`renovate.json` / `renovate.json5` / `.renovaterc` / `.renovaterc.json` / `.renovaterc.json5`)
- composite action 定義 (`action.yml` / `action.yaml`)

CI が検出しなかったことは「ポリシーに適合している」ことを意味しません。下の「自動検出しないもの」は、これまでどおりレビューで判断します。

**CI が自動検出するもの**

| 検出内容                                                                                                 | 対応する MUST NOT                      |
| -------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `GITHUB_TOKEN` 以外の `secrets.*` 参照、および `secrets: inherit`                                        | LLM / 従量課金 API キーの Secrets 登録 |
| 従量課金 API キーを示す変数名 (`*_API_KEY` / `*_API_TOKEN` / `*_SECRET_KEY` / プロバイダ名付きの鍵・URL) | 同上 (`vars.*` や平文での指定も含む)   |
| 課金可能な LLM / 検索 API のエンドポイントホスト名                                                       | OpenAI 互換エンドポイント経由での利用  |
| サードパーティ Action のタグ参照 (SHA 未ピン留め) — `actionlint` と `zizmor` が検出                      | フルコミット SHA での pin              |

`secrets.*` はホワイトリスト方式です。本リポジトリは `GITHUB_TOKEN` 以外の Secrets を一切使っていないため、**`GITHUB_TOKEN` 以外の参照はすべて違反として検出** されます。

**CI が自動検出しないもの (レビューで判断します)**

- 有料プラン / 有料ライセンス / 有料トライアル / クレジットカード登録を必要とするサービスの導入
- 公開 OSS リポジトリでも Pro プラン以上を要求する SaaS の追加
- リポジトリオーナーへの新規 Secret 発行依頼
- そのサービスが「無料枠」型かどうかの判定
- 既存テスト / lint / セキュリティスキャンのスキップ・無効化
- 既に導入済みのツールとの機能重複

**除外マーカー `free-policy: allow <理由>` の使用条件**

対象行に `free-policy: allow <理由>` を含むコメントを書くと、その行は検出から除外されます。チェックを通すために自己判断で付けてはいけません。

- **MAY**: 誤検知 (課金可能な API に繋がらないことが明らかな行) に付ける。この場合は、誤検知と判断した根拠を PR 本文に **MUST** 記載する。
- **MUST NOT**: 本ポリシーの例外にあたる構成 (実際に Secrets や課金可能な API を使うもの) に、5 章の承認なしで付けること。先に Issue で承認を取得し、承認済みの Issue 番号をマーカーの理由と PR 本文の両方に記載する。
- 誤検知か例外かを判断できない場合は、マーカーを付けずに Issue で相談する (6 章)。

> **運用に関する注記**: `free-policy` チェックは違反を検出すると **job が失敗** します (`enforce: true`)。このチェック (context: `free-policy / Free-only policy check`) は、現時点では `main` ブランチ保護の必須ステータスチェックではないため、失敗していても GitHub 上はマージできてしまいます。必須化されるまでは、**`free-policy` が失敗している PR をレビュー・マージしない** ことを運用で守ります。違反が出ている PR は、原因を取り除くか、上記の条件を満たす除外マーカーでチェックを成功させてからレビューに出してください。

---

## 2. PR を作成する前のチェックリスト (MUST すべて満たす)

- [ ] 追加するサービスが「公開 OSS リポジトリで完全無料で利用可能」であることを、**公式の料金ページ / ドキュメントの URL** で証明している。
- [ ] LLM プロバイダの API キー / 従量課金 API キーを GitHub Secrets に追加していない。`GEMINI_API_KEY` / `OPENAI_API_KEY` / `ANTHROPIC_API_KEY` 等を `secrets.*` から参照する記述が、新規ファイルだけでなく既存ファイルへの追加・変更差分にも含まれていない (PR の diff 全体を確認する。構文的に判定できるものは `free-policy` チェックも検出する)。
- [ ] `free-policy` チェックが成功している (必須ステータスチェックではないが、失敗したままの PR はレビュー・マージしない)。`free-policy: allow <理由>` マーカーを追加した場合は、1.5 節の使用条件を満たし、その理由を PR 本文に記載している。
- [ ] 「無料枠内に収まる前提」の利用ではなく、「課金が一切発生しない構成」であることを PR 本文に明記している。
- [ ] 追加する GitHub Action は **フルコミット SHA で pin** している。
- [ ] `.github/workflows/` 配下の既存ワークフローと機能が重複していないことを確認した。
- [ ] 既存テスト / lint / セキュリティスキャンをスキップ・削除していない。
- [ ] リポジトリオーナーへ新規 Secret の登録を依頼していない。依頼が必要なら PR ではなく Issue で提案している。

## 3. PR 本文に必ず含めるべき情報

PR 説明文には以下を **MUST** で、**日本語で** 含めてください。

1. **目的**: この変更で何を改善したいか (1〜3 文)。
2. **変更内容**: 追加・更新・削除するファイルの一覧。
3. **「公開 OSS で完全無料」の証明**: 公式の料金ページ URL と、無料で利用できる条件の引用。外部サービスを一切追加しない変更ではその旨を明記。
4. **既存ツールとの重複がないことの確認**。
5. **マージ前に必要な手動セットアップ手順**: リポジトリ設定変更や App のインストールが必要なら、オーナーがそのまま実行できる粒度の番号付き手順で書く。
6. **想定リスクとロールバック手順**。
7. **動作確認結果**: ローカルで実行したコマンドとその結果。実行すべきコマンドがない変更（ドキュメントのみの変更など）では、その旨を明記する。

## 4. 言語規約

- PR タイトル、PR 説明文、コミットメッセージ、ソースコード内コメント、ドキュメントは **日本語** で記載する。
- 技術用語 (GitHub Actions / CI/CD / API キー / Marketplace 等) と識別子は原語のままでよい。
- コミットメッセージおよび PR タイトルは [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) に従う。

## 5. 例外申請プロセス (MUST)

本ポリシーから外れる導入を検討したい場合は、PR を作成する **前に** Issue で提案し、リポジトリオーナー (@genzouw) の明示的な承認を **MUST** 取得してください。承認済みの場合だけ例外として PR を作成できます。承認のない有料サービス導入 PR はクローズ対象とします。
Issue では「なぜ既存の無料サービスでは目的を達成できないか」「課金リスクをどう管理するか」を明確に書いてください。

「とりあえず PR を作って判断してもらう」というアプローチは取らないでください。レビューコストが発生し、結果として全員の生産性を下げます。

## 6. 判断に迷ったときのフローチャート

迷ったら次の順番で安全側に倒してください。

1. 課金が一切発生しないことに 100% の確信が持てない → PR を作らずに Issue で提案する。
2. 既存ツールと重複しているか判断できない → PR を作らずに Issue で提案する。
3. 新規 Secrets / 追加権限が必要である → PR を作らずに Issue で提案する。

## 7. 本ポリシーの適用範囲

本ポリシーはまず本リポジトリ ([genzouw/docker-jq](https://github.com/genzouw/docker-jq)) に適用されます。[@genzouw](https://github.com/genzouw) が公開する他の公開リポジトリへ展開する場合は、当該リポジトリのルートに同様の `AGENTS.md` を配置してください。
