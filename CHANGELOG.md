# Changelog

Tutte le modifiche a ROQuiz, un commit per riga, raggruppate per versione e
per giorno.

<!--
QUESTO FILE È GENERATO: non modificarlo a mano, le modifiche verrebbero perse
alla rigenerazione successiva. Per aggiornarlo:

  .github/scripts/generate-changelog.sh            # commit nuovi -> [Unreleased]
  .github/scripts/generate-changelog.sh X.Y.Z      # commit nuovi -> [X.Y.Z]

Di norma non serve: lo rigenera e lo committa il workflow di release, dopo aver
creato il tag. Vedere .github/RELEASING.md.

Dato che le voci sono i messaggi di commit, la leggibilità di questo file
dipende da quanto sono descrittivi: conviene curarli, o fare squash prima del
merge.
-->

## Versioni

- [2.0.0](#200---2026-09-13)
- [1.11.5](#1115---2025-07-23)
- [1.11.4](#1114---2025-07-02)
- [1.10.1](#1101---2024-01-18)
- [1.10](#110---2023-12-17)
- [1.9.0](#190---2023-12-16)
- [1.9](#19---2023-12-04)
- [1.8](#18---2023-09-02)
- [1.7](#17---2023-08-05)
- [1.6](#16---2023-07-15)
- [1.5](#15---2022-07-16)
- [1.4](#14---2022-01-20)
- [1.3](#13---2022-01-15)
- [1.2](#12---2021-07-21)
- [1.1](#11---2021-07-10)
- [1.0](#10---2021-07-10)

## [Unreleased]

## [2.0.0] - 2026-09-13

### 2026-09-12

- ci(release): group the notes by kind and move them to the bottom ([`f0efaec`](https://github.com/mikyll/ROQuiz/commit/f0efaecbd0417d36bb22dfee03d96684a72b8a5d))
- ci(questions_validate): rename workflow ([`d9f1bec`](https://github.com/mikyll/ROQuiz/commit/d9f1bec2534c337d9e7418b4b40ba2222d82ffb8))
- docs: update README ([`d58255f`](https://github.com/mikyll/ROQuiz/commit/d58255f719d119d3b6ed7aa617a94c8b77a06e26))
- fix(questions): keep offering a declined update to an explicit check ([`3878532`](https://github.com/mikyll/ROQuiz/commit/38785328bb43d8ddc4e613929c27d002bcf28137))
- fix(contributors): cap the detail card width like the rest of the app ([`a70a3e3`](https://github.com/mikyll/ROQuiz/commit/a70a3e3455a791f7a9780c326f4e1db25d26c259))
- docs: update CHANGELOG for the automated flow ([`c67e328`](https://github.com/mikyll/ROQuiz/commit/c67e328807ec00bb07fa89ea5beace92aed94886))
- docs: document the automated changelog flow ([`591063d`](https://github.com/mikyll/ROQuiz/commit/591063d98aace70b8507a7af376ceb84cdb97840))
- ci(release): generate and commit the changelog during the release ([`8dddcf7`](https://github.com/mikyll/ROQuiz/commit/8dddcf7df947a0f070df0ec352fae024de7c1533))
- chore(changelog): ignore the workflow's own changelog commits ([`8f110e3`](https://github.com/mikyll/ROQuiz/commit/8f110e3bbba9bf9116a06c5d81c244acff685a54))
- ci(release): update version hint ([`9c038bd`](https://github.com/mikyll/ROQuiz/commit/9c038bd8ca5ba1c93ddce16ccc2860a1acf81b61))
- docs: regenerate the changelog against this repository's history ([`6749810`](https://github.com/mikyll/ROQuiz/commit/6749810cb53e731f7a1528d27e08af9d71aa5708))
- docs: changelog for 2.0.3 ([`539dceb`](https://github.com/mikyll/ROQuiz/commit/539dceb74e15b5a9c75ee735d0367939e7928354))
- docs: clarify that the key password equals the keystore one ([`8a2165e`](https://github.com/mikyll/ROQuiz/commit/8a2165e5dad695044ae576aa660d2ff2d96f7f43))

### 2026-09-09

- docs: group changelog commits by day ([`f7bed3f`](https://github.com/mikyll/ROQuiz/commit/f7bed3f03bb143350b8148f1e5bdd11727b8b2c4))
- docs: link the changelog sections from a table of contents ([`db68f01`](https://github.com/mikyll/ROQuiz/commit/db68f01427cebfecc4f146c27be9c1a80660f2e0))
- docs: generate the keystore outside the repository ([`7f5def2`](https://github.com/mikyll/ROQuiz/commit/7f5def29b4216f588fd4ddf7313718ce3a5573cb))

### 2026-09-04

- chore: never track signing keys anywhere in the repo ([`ca67807`](https://github.com/mikyll/ROQuiz/commit/ca67807eee2f4b00bdff6afccf06f9ace6b5bdbb))
- docs: document the release procedure ([`25ed9db`](https://github.com/mikyll/ROQuiz/commit/25ed9db6ff5cb38462a847d45996ef81cea77c3a))
- docs: generate CHANGELOG.md from the commit history ([`2057ffe`](https://github.com/mikyll/ROQuiz/commit/2057ffe231ce7b23d991334da95fa8f1ab336e5e))
- ci: make Android releases installable over each other ([`3a8a9da`](https://github.com/mikyll/ROQuiz/commit/3a8a9da115c9753f8d579cd7afe15adf9ae15f5b))

### 2026-08-27

- docs: add the 2.0.2 changelog section ([`f7d18cc`](https://github.com/mikyll/ROQuiz/commit/f7d18ccbb0f7ae2579020c3c4dcd14f437219686))
- ci: run the test suite only after the version check passes ([`08a6d63`](https://github.com/mikyll/ROQuiz/commit/08a6d6352621edcd825642290c21aa68a654df08))
- ci: build the release body from CHANGELOG.md ([`5176dbd`](https://github.com/mikyll/ROQuiz/commit/5176dbdd312e6aa15bd4b2622c56a17d672831c1))
- docs: add a CHANGELOG in Keep a Changelog format ([`6e0504d`](https://github.com/mikyll/ROQuiz/commit/6e0504d3c2c9bb426e9629186add10898b959ab3))
- ci: gate releases on a pre-flight check and the test suite ([`b134a4a`](https://github.com/mikyll/ROQuiz/commit/b134a4a6e8c0b5b04d326146f4a8b898a1188dd3))
- test: align confirmation level expectations with the full default ([`ed74bc7`](https://github.com/mikyll/ROQuiz/commit/ed74bc7dae64a89191917bc55f28989822a7d09b))

### 2026-08-26

- ci: host a single app version on GitHub Pages ([`abbc189`](https://github.com/mikyll/ROQuiz/commit/abbc18961d3fc5f599e8bb2a5da42ee3a429e4f7))
- ci: derive web base-href from the repository name ([`353ba92`](https://github.com/mikyll/ROQuiz/commit/353ba9233ad59f5dfbe09d34b1b1c4af88df92d2))

### 2026-07-11

- ci: host coexisting app versions on GitHub Pages ([`1f46863`](https://github.com/mikyll/ROQuiz/commit/1f46863cbb2aed91d0915ba36cce02308d6e51c3))
- ci: build and tag a specific commit in the release workflow ([`a5bfc0c`](https://github.com/mikyll/ROQuiz/commit/a5bfc0ce804f9c1e2922f018b478607d9f6552c9))
- ci: rename release assets to roquiz_v<version>_<platform> ([`a30b6be`](https://github.com/mikyll/ROQuiz/commit/a30b6be5f46bbac12f6c53b4f4b98f44f6535f42))
- ci: upgrade and generate contributor assets ([`bb68a85`](https://github.com/mikyll/ROQuiz/commit/bb68a852d03c33024ab73e3e0b56b5c25e3a0282))
- ci: rename deploy workflow ([`c17795e`](https://github.com/mikyll/ROQuiz/commit/c17795ef9621918d320ec0455fc9dc721df7408f))
- chore: gitignore Flutter-generated plugin registrants and contributors assets ([`b5aeeb0`](https://github.com/mikyll/ROQuiz/commit/b5aeeb0c0e577e74b028acff0f1e28502044cdf7))
- chore: add pubspec.lock ([`c11ad30`](https://github.com/mikyll/ROQuiz/commit/c11ad30c3ad21ab29308d48b455d752e257e126e))

### 2026-07-10

- fix(theme): match the switch thumb colour to the buttons ([`6a0ba3b`](https://github.com/mikyll/ROQuiz/commit/6a0ba3bb88aedd68065a80c6f746f89890fbb504))
- fix(theme): match icon-button colour to the elevated buttons ([`da55852`](https://github.com/mikyll/ROQuiz/commit/da558524d1dcb170d42b0153c5e307c0a4c1b2b2))
- feat(settings): add visible "check now" buttons for the update checks ([`b63919a`](https://github.com/mikyll/ROQuiz/commit/b63919ad72b3adbec4c73fb1a7d3833c95dd1738))
- fix(questions): stop the bundled set nagging for updates every startup ([`be57c98`](https://github.com/mikyll/ROQuiz/commit/be57c987b602a978bd01fc5428891a46aa0af40d))
- chore: update application id to com.mikyll.roquiz ([`7139aaf`](https://github.com/mikyll/ROQuiz/commit/7139aaffbc5e38eacf11edf57da1950901ecd1c8))
- ci(release): add manual release workflow for Android, Linux, and Web ([`cff5cd1`](https://github.com/mikyll/ROQuiz/commit/cff5cd166f40fff1b9ad0b2e922b2a79f2a8a39a))
- ci: fix deploy_to_gh_pages ([`97cb708`](https://github.com/mikyll/ROQuiz/commit/97cb708eeef43de9248bf147ba40c1f5b12907cc))
- build(android): add inert release-signing scaffold falling back to debug ([`5a66683`](https://github.com/mikyll/ROQuiz/commit/5a666837a4e1c62bcbe1f944889f59d546ec7715))
- build(android): bump Android Gradle Plugin to 8.9.1 ([`678a74c`](https://github.com/mikyll/ROQuiz/commit/678a74c4578f1d431da192bf0f3c935ba642eadd))

### 2026-07-09

- fix(settings): set default alert level to full ([`ecc968c`](https://github.com/mikyll/ROQuiz/commit/ecc968c6bcf66d5715ca3bdd2434e0e070c1804b))
- test(settings): cover lockQuizConfig entry disabling ([`c13a98d`](https://github.com/mikyll/ROQuiz/commit/c13a98d0cb21a8910998296e211d3c79dba60316))
- fix(quiz): lock quiz-config settings when opened from the quiz ([`d00ee02`](https://github.com/mikyll/ROQuiz/commit/d00ee02a05a89ef48056893fd7bd981e7287154e))
- feat(settings): add lockQuizConfig to disable quiz-config entries ([`1625118`](https://github.com/mikyll/ROQuiz/commit/1625118bc318787049f469d1ed1a786c52685fa1))
- fix(menu): clamp requested quiz questions to the selected pool ([`e78b948`](https://github.com/mikyll/ROQuiz/commit/e78b948ed14c605a6da1fa21931c5e35554b3641))
- fix(quiz): use available question count to avoid RangeError ([`8eb6ce8`](https://github.com/mikyll/ROQuiz/commit/8eb6ce84b08f6961440f26558b285f1e66767f7d))

### 2026-07-08

- fix(snackbar): prevent stacking and clear on navigation ([`e83cfdf`](https://github.com/mikyll/ROQuiz/commit/e83cfdf33d3844640c35a9411a1ba98a5d61534e))
- refactor(contributors): split fetch logic into model layer and move CLI to bin/ ([`ef6f03d`](https://github.com/mikyll/ROQuiz/commit/ef6f03d0c7119aada225b0317f5083918e14247e))
- ci(questions): add semantic validation and fix stale asset paths ([`8528e6d`](https://github.com/mikyll/ROQuiz/commit/8528e6d034e0b4c60a9ebd26ec4963dc9eb862b1))
- refactor(questions): split parser into model layer and move CLI to bin/ ([`f589546`](https://github.com/mikyll/ROQuiz/commit/f5895465597545217aaf3e8b32dc9daab2732a62))
- ci: uncomment workflows, disable on-push trigger ([`50dca43`](https://github.com/mikyll/ROQuiz/commit/50dca4364c8a453fcfc461f76ab07f9a7de905ef))
- Aggiunta 4 nuove domande quiz 7/07/26 ([`02ce40d`](https://github.com/mikyll/ROQuiz/commit/02ce40da6fa5e20b5d89b4bc530406fa2feb8902))

### 2026-07-07

- chore: remove questions_explained ([`f21dafa`](https://github.com/mikyll/ROQuiz/commit/f21dafa990d5ce56e2c05e50c6d6182f37f342c1))
- doc: revert README ([`2af2900`](https://github.com/mikyll/ROQuiz/commit/2af290018db3fcf22d92fc6d90439faa6a2f92f1))
- ci: disable workflows ([`2982d26`](https://github.com/mikyll/ROQuiz/commit/2982d26ec808f8df2473a009318348b4f046c22d))
- docs: update README.md ([`2b69dba`](https://github.com/mikyll/ROQuiz/commit/2b69dbac991b5a7abb67dc8923b039abc3c7af1c))
- refactor: move app-mobile to legacy/ ([`d0260db`](https://github.com/mikyll/ROQuiz/commit/d0260db359b7588bac0f91d6a5b413b646ac2182))
- refactor: move app-desktop to legacy/ ([`2c3aa75`](https://github.com/mikyll/ROQuiz/commit/2c3aa756d7721114f7e00a3484df646e640bb91c))

### 2026-07-05

- feat(settings): add hidden label shortcuts to run the update checks manually ([`307b69a`](https://github.com/mikyll/ROQuiz/commit/307b69ab3700a4a5d3cf097c64a8a5428ecb3951))
- feat(settings): implement the app update check on startup ([`4a6c1c4`](https://github.com/mikyll/ROQuiz/commit/4a6c1c4cbb19c0d5dca67d671407f0d2a75960cf))
- feat(questions): add import/export buttons and group file I/O on the right ([`1ce0729`](https://github.com/mikyll/ROQuiz/commit/1ce072925cbb39b2b5a37c069f0b6acfa86facc7))
- fix(questions): disable the unimplemented file-edit button in debug, hide it in release ([`b381994`](https://github.com/mikyll/ROQuiz/commit/b381994605f92d74ba2c45295a280cdca286a43a))
- fix(quiz): discard the quiz when leaving mid-run instead of saving it ([`49a6ff3`](https://github.com/mikyll/ROQuiz/commit/49a6ff34197ba32845df81a601711e9996c2cd31))
- fix(grade): show only the integer part in the grade string ([`66f995d`](https://github.com/mikyll/ROQuiz/commit/66f995dd501c96ef17b7109c94b2a738e62f0e4d))
- feat(settings): clarify written-grade field with an example placeholder ([`a124157`](https://github.com/mikyll/ROQuiz/commit/a124157da51463c43b48db29d112ba95ad8d0f53))
- feat(edit): accelerate undo/redo buttons on press-and-hold ([`4ff9bbb`](https://github.com/mikyll/ROQuiz/commit/4ff9bbb30bd51d881eb055dc45d936b6b4575dea))
- style(settings): update tooltip text ([`3a7df64`](https://github.com/mikyll/ROQuiz/commit/3a7df64665057d12ddda8cd51323a0e6aa10edca))
- fix(settings): hide the empty accessibilità section in release ([`f642b3b`](https://github.com/mikyll/ROQuiz/commit/f642b3b1511a6450d51269aa070438a94df5e7c7))
- feat(quiz): use the whole selected-topics pool when full-topics is on ([`b7abe08`](https://github.com/mikyll/ROQuiz/commit/b7abe086d7bedab21cb03246b4d13ba31e70f63a))
- feat(settings): grey out the unimplemented language and github-token entries ([`84e058e`](https://github.com/mikyll/ROQuiz/commit/84e058e1c96f802dfb47f13aa54f178d794c3ece))
- fix(setting-entry): make disabled entries ignore hover and taps ([`5f9f64f`](https://github.com/mikyll/ROQuiz/commit/5f9f64fea79e2822c9e78ae6216dfec71b00a085))
- feat(confirmations): add a 3-level confirmation setting and route quiz/history/settings actions through it ([`ace630d`](https://github.com/mikyll/ROQuiz/commit/ace630d1f5266277355de26494cab8ca033c4a21))

### 2026-07-04

- feat(settings): show the check-for-new-questions toggle in release ([`55150a3`](https://github.com/mikyll/ROQuiz/commit/55150a31b0a1b034bd4e512fecc7b718d2a5acf6))
- feat(questions): confirm remote updates via a shared flow for the list button and startup check ([`b7942fe`](https://github.com/mikyll/ROQuiz/commit/b7942fe656b33f5fbf9a41bea714c0d90d2e52b0))
- feat(question-repository): track file source and notify custom sets of remote updates ([`cf5b821`](https://github.com/mikyll/ROQuiz/commit/cf5b8216037eae34f4f86c54f0234f683a7aa72a))
- fix(icon-button-acceleration): reset the hold loop on release so rapid taps don't skip steps ([`5c595fa`](https://github.com/mikyll/ROQuiz/commit/5c595fa324710a96741a5b8e06dae269b9f64599))
- feat(questions): open search with Ctrl+F and close it with Esc ([`32cb747`](https://github.com/mikyll/ROQuiz/commit/32cb74732667ef8529eb14cdf05c6ea39bf840b9))
- feat(questions-edit): add a restore-all button that discards edits, disabled when unchanged ([`aa607fb`](https://github.com/mikyll/ROQuiz/commit/aa607fbc0825d80b8c3c19fb34e24666ee5bfb77))
- feat(question-card): add a tooltip to the report button ([`9254082`](https://github.com/mikyll/ROQuiz/commit/925408297c17452642df3677543744d2716977d2))
- feat(questions): flag user-added questions as custom and hide the report button for them ([`19fdbc4`](https://github.com/mikyll/ROQuiz/commit/19fdbc419664f2ee0a6bb562fd7a3b1bb3bf0423))
- feat(questions-edit): persist edits as a custom question set and refresh on return ([`0456b6d`](https://github.com/mikyll/ROQuiz/commit/0456b6d6daa9c49d9fe2278c0f4ce3347b645dc3))
- fix(question): serialize toYaml as quoted YAML for lossless round-trip ([`1fc8fb1`](https://github.com/mikyll/ROQuiz/commit/1fc8fb1e483f6b21d6bf75a644d97ae2bef03a59))
- feat(questions-edit): scroll to the newly added question ([`79d7aec`](https://github.com/mikyll/ROQuiz/commit/79d7aecab6f6fec03c5f9c7a597d5bbdd430cb54))

### 2026-07-03

- fix(settings): reach off-screen scroll targets by pre-building the list ([`e7fe952`](https://github.com/mikyll/ROQuiz/commit/e7fe952f0ceb3c9b203947960beeec48811b2997))
- feat(menu): link the quiz-summary figures to their settings and topics entries ([`dd56fd6`](https://github.com/mikyll/ROQuiz/commit/dd56fd681ebf802fd57fffd631bdd7b2a2c6a4ff))
- feat(settings): show the quiz-questions and timer entries and scroll to a requested one ([`2de5084`](https://github.com/mikyll/ROQuiz/commit/2de5084c170f6d150a58bd533c28ee58fb3d4e49))
- feat(report): mark the confirm button as opening an external link ([`da3db1c`](https://github.com/mikyll/ROQuiz/commit/da3db1cd3c406506b21afca457ba700a7c149715))
- refactor(report): rename the question-body template to "Corpo domanda errato" ([`59a21c5`](https://github.com/mikyll/ROQuiz/commit/59a21c5a562d8ec5cf1908523c28457a2dd38c5b))
- feat(report): show answers and highlight body edits in the question-body template ([`dd8c6b9`](https://github.com/mikyll/ROQuiz/commit/dd8c6b9897c63702f1d0df497b2e93e3e325ef28))
- fix(report): keep at most one correct answer selected in the report ([`7cfa9d9`](https://github.com/mikyll/ROQuiz/commit/7cfa9d93d5365802c1032254844b8d99d467cc7a))
- feat(report): edit answers in place in the wrong-answer template ([`ba25ff4`](https://github.com/mikyll/ROQuiz/commit/ba25ff4f23b5df33483173e43893559a7ce352ba))
- feat(report): add question-body and wrong-answer report templates with a template picker ([`5a4050c`](https://github.com/mikyll/ROQuiz/commit/5a4050c12d5833388c7f416f035f4e1be9650310))
- feat(report): show the question body as a read-only field in the report dialog ([`7ffceb4`](https://github.com/mikyll/ROQuiz/commit/7ffceb401587f1170e5828bbd3265cecace70bc4))
- feat(settings): show the entry tooltip only when hovering the label ([`7320f22`](https://github.com/mikyll/ROQuiz/commit/7320f226988127fea930b35296274da00a25e018))
- feat(result-card): flag a missing written grade with an inline warning icon ([`b6050a6`](https://github.com/mikyll/ROQuiz/commit/b6050a63320abd27d0032a6ac3915fb3c96585eb))

### 2026-07-02

- feat(back-button): trigger the back action with the Esc key ([`0af2a8d`](https://github.com/mikyll/ROQuiz/commit/0af2a8dc7564a37c3a69f64b876991717fbf2f70))
- feat(questions): persist the question repository and update it from the GitHub remote ([`c340e17`](https://github.com/mikyll/ROQuiz/commit/c340e170773b57d3b567363339ae81f6cd303fbd))

### 2026-06-30

- feat(quiz): make on-screen nav arrows repeat on press-and-hold ([`23b3074`](https://github.com/mikyll/ROQuiz/commit/23b307425bc9fd13fde826c91de5ac1a00276c04))
- chore(edit): remove dead command-pattern draft superseded by edit_question ([`b7a7b74`](https://github.com/mikyll/ROQuiz/commit/b7a7b7469e108e2598da190e029ba7567c6b769e))
- feat(grade): base written-grade display on the live global setting ([`64b6138`](https://github.com/mikyll/ROQuiz/commit/64b61388b0ef5cb344ff4f49d1ba6a12017f57fe))

### 2026-06-26

- feat(stats): base grade stats on quiz grade, summarise final grade only where a written grade exists ([`7f91b35`](https://github.com/mikyll/ROQuiz/commit/7f91b35c70d042b32634c899808bf24068b4d263))
- feat(stats): add Statistiche view with summary, grade trend, distribution and weak topics ([`6825503`](https://github.com/mikyll/ROQuiz/commit/6825503e996104ad474a4986fe7cfb38d63f0336))
- refactor(history): extract shared GradeBadge and use it in the quiz detail bottom bar ([`5bac48a`](https://github.com/mikyll/ROQuiz/commit/5bac48a9c15e82869fdc9779c54c426ad03334b0))
- refactor(quiz): make quiz & history bottom bars shrink the middle gap before scaling ([`984614c`](https://github.com/mikyll/ROQuiz/commit/984614c0b1246bc20d8c990b84e1282d0af218ee))
- fix(quiz): make the debug fill-correct-answers button readable in dark mode ([`ab4f64c`](https://github.com/mikyll/ROQuiz/commit/ab4f64c33c854cbb2c0205004434d3069e7f8ec6))

### 2026-06-25

- fix(question-card): show selected-answer border in dark mode via colorScheme.primary ([`8afcc60`](https://github.com/mikyll/ROQuiz/commit/8afcc6085bc4953ba0e3bd759948219d92b15518))
- refactor(quiz): replace debug max-grade switch with a fill-correct-answers button ([`fbf0321`](https://github.com/mikyll/ROQuiz/commit/fbf0321cf576a807c3e75fdbb790a45b2d0c7ece))
- feat(quiz): keyboard controls — arrows change question, number keys toggle answer ([`c3561a3`](https://github.com/mikyll/ROQuiz/commit/c3561a3dcee8cf9cc9cf3e474da81343d03b0e10))
- refactor(menu): make home layout scroll-safe and dedupe menu buttons ([`6497317`](https://github.com/mikyll/ROQuiz/commit/6497317c597884b6438c9ca398e25a2d370938d2))
- feat(quiz): grey out nav arrows at the first/last question ([`29c8e09`](https://github.com/mikyll/ROQuiz/commit/29c8e09ab723c1e40569ddc16fb96a965701b36c))
- feat(quiz): select all correct answers via the debug max-grade switch ([`bcaf584`](https://github.com/mikyll/ROQuiz/commit/bcaf584c1550a849a797a8964fe3ad0e7a7ab372))
- fix(quiz): match bottom nav arrow color to the Termina button ([`0fe14ba`](https://github.com/mikyll/ROQuiz/commit/0fe14baf6dfe9a6e88b2fc4a50ba8f186af50402))
- feat(settings): restore default settings from the refresh button ([`27231a9`](https://github.com/mikyll/ROQuiz/commit/27231a947c97ded05399a1b6234232858f0ab2c3))
- feat(bottom-bar): shrink toolbar icons to fit narrow screens ([`c9d8afe`](https://github.com/mikyll/ROQuiz/commit/c9d8afe2171bc1193fd8ec6c69f5d86249eaf14a))

### 2026-06-24

- feat(settings): grey out disabled setting entries ([`f679cca`](https://github.com/mikyll/ROQuiz/commit/f679cca24b4372b604f11d852f1dcbe3e3842313))
- fix(settings): keep 3-digit stepper values from being clipped ([`d701321`](https://github.com/mikyll/ROQuiz/commit/d701321445f2cc41aac61ddd722cccca0d045ceb))
- feat(settings): add press-and-hold acceleration to quiz steppers ([`19019e8`](https://github.com/mikyll/ROQuiz/commit/19019e876b53b0e6a5ec8f46953954421cef6db3))

### 2026-06-23

- feat(history): reject importing a newer-schema history file ([`bcc3e63`](https://github.com/mikyll/ROQuiz/commit/bcc3e6393366bbaecdc017b98d3d75a5aa9347f8))
- fix(settings): make question/timer steppers update their value ([`19a41c1`](https://github.com/mikyll/ROQuiz/commit/19a41c18a014ec10ea5f27030cc8f7769f84b6b3))
- refactor(persistence): rename QuizRepository to CompletedQuizRepository ([`e08234f`](https://github.com/mikyll/ROQuiz/commit/e08234f2cf253d28a94e53fb562ed184f6d6bd16))
- feat(history): report skipped duplicates and invalid entries on import ([`a9b6ab2`](https://github.com/mikyll/ROQuiz/commit/a9b6ab213bc61e34d2edd4b2ac5972a203bedf69))
- fix(settings): clamp written grade input to a max of 32 ([`f0c6d67`](https://github.com/mikyll/ROQuiz/commit/f0c6d671e81c05c2018325d0292cf39ad5bb2440))
- fix(settings): size quiz number fields to fit their max value ([`fd385d4`](https://github.com/mikyll/ROQuiz/commit/fd385d4e60a962979811dad2e39500b708a01ce6))
- fix(settings): keep focus while typing the written grade ([`dae3e9b`](https://github.com/mikyll/ROQuiz/commit/dae3e9b49c8eaa7ec1d29eb4b0f35a8a7254b45e))
- fix(settings): keep scroll position when toggling a setting ([`6d50265`](https://github.com/mikyll/ROQuiz/commit/6d50265eeba7064d0545f8bcf3b0d03d18cd00bb))
- feat(history): highlight cum laude grade badge ([`4b17407`](https://github.com/mikyll/ROQuiz/commit/4b17407cdb3f71b491aa723eaa06bc248dd75c15))
- feat(history): redesign completed-quiz card with grade badge ([`f649eea`](https://github.com/mikyll/ROQuiz/commit/f649eeaa2d959f2a46b5c324b1bb9ead7c7ac215))
- refactor(history): store written grade and derive the displayed grade ([`28ef776`](https://github.com/mikyll/ROQuiz/commit/28ef7767e910d9b36178674c3e130d0f2a6f1a7d))
- fix(time): correct getTimeString hour rollover and add date helper ([`619a67b`](https://github.com/mikyll/ROQuiz/commit/619a67b2fdb13dc0cf1cf7e90e1b27880b81d8d8))
- feat(history): let import merge into or overwrite existing history ([`b33c447`](https://github.com/mikyll/ROQuiz/commit/b33c447223984b3f21efd2e5f26e6eb3e6d1573c))

### 2026-06-22

- fix(history): guard import against empty file selection on web ([`6b9597e`](https://github.com/mikyll/ROQuiz/commit/6b9597e310b7ae43034b95fa04881c2c4db6ebba))
- fix(history): upgrade file_picker to 11.x to fix web import MissingPluginException ([`2357fbb`](https://github.com/mikyll/ROQuiz/commit/2357fbbc70c19f94ee283ddd242977dd3155749b))
- fix(question-card): match history selection colors for border, fill and check icon ([`551155a`](https://github.com/mikyll/ROQuiz/commit/551155acb6b8a9645020924a815a6f9049991f80))

### 2026-06-21

- feat(history): add multi-selection with bulk delete and export ([`78a2b05`](https://github.com/mikyll/ROQuiz/commit/78a2b059d3e02695791c61d5aea5235ace9908f5))
- feat(history): support bulk removal and subset export in repository ([`a00cbb7`](https://github.com/mikyll/ROQuiz/commit/a00cbb76fd7f0f485f1c97b5af7e1abb9dfbc11b))
- refactor(questions): use shared SelectionController and SelectAllCheckbox ([`94f7336`](https://github.com/mikyll/ROQuiz/commit/94f7336400ffd75104f2fd3511fdd7e4bc3b5498))
- refactor(selection): add shared SelectionController and SelectAllCheckbox ([`b4e2c14`](https://github.com/mikyll/ROQuiz/commit/b4e2c14391db76112240afeee9f3fcc13e8efb83))

### 2026-06-19

- feat(history): use compact timestamp in exported history filename ([`7db5288`](https://github.com/mikyll/ROQuiz/commit/7db528826b03be39f8a365f880b4523516d38414))
- feat(history): include timestamp in exported history filename ([`ce2c019`](https://github.com/mikyll/ROQuiz/commit/ce2c019b429978b52db8572b59219f54d6506432))
- feat(history): wire import and export buttons in the history view ([`af26fbb`](https://github.com/mikyll/ROQuiz/commit/af26fbb73817037f7429ff066a90d15c10d70b0e))
- feat(history): add json export and replace-all import to the repository ([`78c4149`](https://github.com/mikyll/ROQuiz/commit/78c4149a125095778e88709548f8a2b51ad160dc))
- chore(deps): add file_picker and file_saver for history import/export ([`63c5da0`](https://github.com/mikyll/ROQuiz/commit/63c5da0f21a186aa41a61b4ad0b1b8422ef9d2ab))
- feat(history): add clear-history button with confirmation dialog ([`5ed1de6`](https://github.com/mikyll/ROQuiz/commit/5ed1de646be4ee82ad526fca14aad7cec0c376fd))
- fix(history): prevent duplicate entries by making quiz end idempotent ([`dff90e7`](https://github.com/mikyll/ROQuiz/commit/dff90e7014ee1aadde255e53ddec8ed2731b6d13))
- feat(history): save completed quizzes and load history from the repository ([`2b7d176`](https://github.com/mikyll/ROQuiz/commit/2b7d1763e52900e17092f5f12130ddff8177c5c2))
- feat(persistence): implement hive-backed quiz history repository ([`0a3a94f`](https://github.com/mikyll/ROQuiz/commit/0a3a94f0183a5e6febe773e6b5950d0e6ceda867))
- feat(model): add json serialization with non-shuffling history rehydration ([`3c59c4d`](https://github.com/mikyll/ROQuiz/commit/3c59c4dec2937fa6cfe4169d62f6a612fd6ab867))
- chore(deps): add hive and hive_flutter for local quiz history ([`9741aeb`](https://github.com/mikyll/ROQuiz/commit/9741aeba5d2467a1ce7260fb23b3c64bfa3388d4))
- refactor: remove credits.json ([`7192056`](https://github.com/mikyll/ROQuiz/commit/7192056fcc0389a61bc9d0754722823c1b60e78f))

### 2026-06-18

- test(contributors): cover fetch CLI parsing and ContributorInfo ([`1adca34`](https://github.com/mikyll/ROQuiz/commit/1adca3438bacd6f985b7267a1fc5c45bbe4acdeb))
- refactor(contributors): generate data under assets/contributors/ and stop committing it ([`8ec4a10`](https://github.com/mikyll/ROQuiz/commit/8ec4a102d369dc4f423c5cb7da0fcac6a655f9ea))

### 2026-06-17

- feat(contributors): scatter bubbles randomly without overlapping until the surface is full ([`b90865b`](https://github.com/mikyll/ROQuiz/commit/b90865ba77ea2d097c3921b7479f9dfde5d65190))
- feat(contributors): generate contributors.yaml from GitHub API (with co-authors) and consume it in the view ([`c9c080f`](https://github.com/mikyll/ROQuiz/commit/c9c080fa6674b372ca0ba8f5ce16e1b2b48b0732))
- fix(domande): correct answer C -> A ([`b49e7b8`](https://github.com/mikyll/ROQuiz/commit/b49e7b84df054cf192957aa6b13412fce818d793))
- wip: misc quiz/question view and repository updates ([`499ff77`](https://github.com/mikyll/ROQuiz/commit/499ff77746a8654a594a6627289ade718a226ca0))
- feat(history): rework history view with per-quiz detail screen ([`5b6a0cf`](https://github.com/mikyll/ROQuiz/commit/5b6a0cf5d3a6594dffad4f75435b975655e98d10))
- feat(menu): add import/export actions with icons ([`e02265f`](https://github.com/mikyll/ROQuiz/commit/e02265f194705cfea232ab36936e874973366673))
- fix: update questions file ([`a55dace`](https://github.com/mikyll/ROQuiz/commit/a55dacebe8b83056dc69202a55aa489a486fb98a))
- fix(domande): correct answer C -> A ([`be227af`](https://github.com/mikyll/ROQuiz/commit/be227afa96f0d5aa452dac65bac99dcbce19335b))

### 2026-06-16

- fix(contributors): resume bubble drift without jump and keep detail card hoverable ([`278c841`](https://github.com/mikyll/ROQuiz/commit/278c841f7462cefe10619df726d3f587afded97e))
- fix(contributors): freeze active bubble in place to stop hover flicker ([`89c3dca`](https://github.com/mikyll/ROQuiz/commit/89c3dcad0487418850d61c7f4d2e021722e39399))
- feat(contributors): add floating-bubble contributors view from local YAML ([`0d81eb3`](https://github.com/mikyll/ROQuiz/commit/0d81eb3abe033a8b5c9ef2173c1883fa02665736))

### 2026-06-10

- fix(utils/question): correct duplicate-detection helpers ([`5884c85`](https://github.com/mikyll/ROQuiz/commit/5884c8518d54618ddf535909e92e356f0c637a79))
- fix(view_questions_edit): deep-copy question for undo ([`d4f1fda`](https://github.com/mikyll/ROQuiz/commit/d4f1fdad21667ba6999f0a6d32cd2ad13d8c55f3))
- feat(question): add Question.copy ([`a2120ba`](https://github.com/mikyll/ROQuiz/commit/a2120ba2d40545055bf0ea97fd0c4abb526f4236))
- fix(question_dialog): avoid skipping consecutive empty answers ([`6bab919`](https://github.com/mikyll/ROQuiz/commit/6bab9190301e1a253d6aa23d905fd90730caab7b))
- fix(question_dialog): dispose answer controllers before clear ([`a39b29b`](https://github.com/mikyll/ROQuiz/commit/a39b29b528ab55dbef7575dd679e597c4e6d977e))
- fix(question_dialog): flag duplicate body when adding ([`0e1cfdf`](https://github.com/mikyll/ROQuiz/commit/0e1cfdfdc3928b37abb9976de42af2838d786df4))
- fix(question_dialog): preserve edited question id ([`2b3df93`](https://github.com/mikyll/ROQuiz/commit/2b3df936e700cd9b9d714451c0e06b0974200cfe))

### 2025-11-20

- ci: update_readme.yml ([`62632f4`](https://github.com/mikyll/ROQuiz/commit/62632f46baf85821e04d2e918da797c7f6ab1ff1))
- Update deploy_to_gh_pages.yml ([`0c14145`](https://github.com/mikyll/ROQuiz/commit/0c14145a8de976f3d99b4195eb805a7a5797635b))

### 2025-10-21

- fix(widget/custom_search_bar): remove focus outline, disable search when input is empty ([`3e0d9d2`](https://github.com/mikyll/ROQuiz/commit/3e0d9d2596c454094177be82e27e6a2a01bb2827))

### 2025-10-18

- fix(custom_command): redo bug ([`6d721a0`](https://github.com/mikyll/ROQuiz/commit/6d721a0396522f4cb9940b7efdfdb3ded069aba3))
- fix(widget/report_question_dialog): update answers minLines/maxLines ([`f053fd4`](https://github.com/mikyll/ROQuiz/commit/f053fd4497328c33d26128c76e39271ad623b200))
- fix(view_questions_edit): disable edit in release ([`64c42f5`](https://github.com/mikyll/ROQuiz/commit/64c42f56248e5c2b7a1af0b86d9236c0736e4470))
- fix(widget/question_dialog): answers written backwards issue ([`1dc2992`](https://github.com/mikyll/ROQuiz/commit/1dc29924169bacc6c80615ff598e1ef5b5500ad5))
- fix(view_questions): enabling edit for release ([`5300140`](https://github.com/mikyll/ROQuiz/commit/5300140b40e9a36ff5fafc18feb33cf86653eea9))
- fix(widget/question_dialog): remove _errorAnswers when toggling correct answer or deleting an answer ([`0d8beda`](https://github.com/mikyll/ROQuiz/commit/0d8bedaaf941ddfa44b3cd48f10ac63e6f3b6406))
- fix(widgets/report_question_dialog): report correct answer ([`a136964`](https://github.com/mikyll/ROQuiz/commit/a136964c40b29370e68a85989d461c1d01edbbf4))
- feat: pass topics list to view_questions_edit; add, remove, undo/redo; fix: question_dialog for add operation ([`9ac22cf`](https://github.com/mikyll/ROQuiz/commit/9ac22cf2779e8c2892c8848ecd12a5bc3b074bff))

### 2025-10-17

- refactor(utils): update in result_card ([`85576dc`](https://github.com/mikyll/ROQuiz/commit/85576dc88459557910866be87df0f1efd3f6462f))
- fix(model): use id correctly ([`d75b8fa`](https://github.com/mikyll/ROQuiz/commit/d75b8fa9e5ef608707c5b51cbfeb68e77bd079ea))
- refactor(utils): separate utils in different files ([`bd06bb4`](https://github.com/mikyll/ROQuiz/commit/bd06bb426ef9a3bf5d81127f4ce4ce28ebdaa107))

### 2025-10-16

- fix(view_questions_edit): implement command undo/redo for add operation ([`a4c44c9`](https://github.com/mikyll/ROQuiz/commit/a4c44c97ac9553e82e4ad8679f8c8a3c07e2f5ec))
- fix(widget/question_dialog): update question topic ([`b8ef1e3`](https://github.com/mikyll/ROQuiz/commit/b8ef1e3a63278b2b9d42a5d875fd8aa847ca73e6))
- fix(widget/question_dialog): bug when adding a new question when none are present ([`21c99c0`](https://github.com/mikyll/ROQuiz/commit/21c99c0f7f9ccf2ed09d65297abcf38844fdf72c))
- feat(view_questions_edit): add, remove functions ([`377934f`](https://github.com/mikyll/ROQuiz/commit/377934f5c38fb10b2aca58a0cb652a35852455d2))
- fix: rename palettes to theme_extension; add custom_back_button theme; add clear button theme; use new custom_back_button; ([`194a607`](https://github.com/mikyll/ROQuiz/commit/194a607acf8efc28e347a607ee7b0d2b32281b6e))
- fix(utils): move duplicate functions to utils ([`9421e9a`](https://github.com/mikyll/ROQuiz/commit/9421e9a7a0a07da4a1008aa9592bd3f04801fefb))
- feat(model/utils): add function to get the first available id ([`31b5aec`](https://github.com/mikyll/ROQuiz/commit/31b5aec46c2481e7553d473dc9a8b91a37d9cf96))
- feat(cli/question_parser): add utilities for duplicate check ([`63f3bd3`](https://github.com/mikyll/ROQuiz/commit/63f3bd30aa7804f3f987a6ea1c23d2f5dc0590a6))

### 2025-10-15

- fix(widget/report_question_dialog): move dropdown to title; use proportional constraints for dialog height, based on screen size; use correct border style; pass question id to issue url ([`43bfe11`](https://github.com/mikyll/ROQuiz/commit/43bfe1142cf50f61e4100efa3dcbf8108fbac0a0))
- style(themes): add inputDecorationTheme ([`e76a4fe`](https://github.com/mikyll/ROQuiz/commit/e76a4fea7d7104af62e2d94d07f6a28dafacc0bb))
- fix(view): use correct question id ([`a639ec9`](https://github.com/mikyll/ROQuiz/commit/a639ec9c29fef818b5e71d3a1343222e42ce2888))
- fix(view_questions): auto focus searchbar only when the input text is empty ([`fc21a4f`](https://github.com/mikyll/ROQuiz/commit/fc21a4f37a5d219680795ed64d0b56912063fb2d))

### 2025-10-14

- fix(view_questions): show number of questions found by search ([`105ecc4`](https://github.com/mikyll/ROQuiz/commit/105ecc49e2faf2fa5b414cb1b6b68067ca0ff8e0))
- fix(view_topics): calculate startId for questions list ([`5054cdb`](https://github.com/mikyll/ROQuiz/commit/5054cdb0723056a2ef4d5f7e3cdb67efd5f0814b))
- fix(view_questions): add startId param ([`be507ee`](https://github.com/mikyll/ROQuiz/commit/be507ee0d13c409fb555ae7331e2b713b63be665))
- fix(widget/question_dialog): prevent vertical overflow ([`6c14758`](https://github.com/mikyll/ROQuiz/commit/6c1475834ad1824af249fc84d1bdb4c2c0da1b22))
- fix(widget/separator): add size param ([`2b4efc3`](https://github.com/mikyll/ROQuiz/commit/2b4efc380e0bb8698e253b25edeccad9353bef12))
- fix(widget/question_card): handle report button ([`6af50e9`](https://github.com/mikyll/ROQuiz/commit/6af50e93d1256eb7d488ce5c1dd6621427ffbb7f))
- feat(widget): add report_question_dialog ([`d778f82`](https://github.com/mikyll/ROQuiz/commit/d778f82e8a093427c316078f0c477f357b57b1b1))
- fix(view_settings): enable not-implemented buttons only in debug mode ([`1a42092`](https://github.com/mikyll/ROQuiz/commit/1a420921d80d95e43535be05603eb09eaa3df4f2))
- fix(view_questions): remove separator for list with only one topic; enable not-implemented buttons only in debug mode ([`5fc7747`](https://github.com/mikyll/ROQuiz/commit/5fc77477a643c5de956fe41952871a3dca0a8602))
- fix(view_questions_edit_file): reordered buttons ([`396ca9a`](https://github.com/mikyll/ROQuiz/commit/396ca9a311527a2e50e17ef1c848da50c57837d2))
- chore: update report_correct_answer.it issue template ([`327592a`](https://github.com/mikyll/ROQuiz/commit/327592a07fb5c383fe5a8a99203de1b76b516424))
- chore: update report_correct_answer.it issue template ([`b4d1a61`](https://github.com/mikyll/ROQuiz/commit/b4d1a61f3089bd30624479d3fedb0e10e5809018))
- chore: create report_correct_answer.it issue template ([`f42bd3a`](https://github.com/mikyll/ROQuiz/commit/f42bd3a73dc82b861c8bb9985b52476a5ff323f2))

### 2025-10-13

- fix(view_questions): update questions_edit transition ([`21fa547`](https://github.com/mikyll/ROQuiz/commit/21fa547d6fc217d5e6c1d41c3f00cfbf16d3fac0))

### 2025-10-11

- fix(view_settings): add tooltips ([`5507be2`](https://github.com/mikyll/ROQuiz/commit/5507be21922c043fa7a7c0ce83a12297325704ff))
- fix(widget/setting_entry): add tooltip ([`4961543`](https://github.com/mikyll/ROQuiz/commit/49615437d32b67954a3872004dce2336ac22d24a))
- fix(widget/constrained_appbar): add padding to title ([`c74a8ad`](https://github.com/mikyll/ROQuiz/commit/c74a8ad51b7e92c69a1c59b5bd8a6811a861256e))
- fix(view_questions_edit): remove useless text ([`41cd7ab`](https://github.com/mikyll/ROQuiz/commit/41cd7ab10a6018d36f02b68ca49e844b095a3a73))
- feat(model/utils): add functions to get device size ([`1f9d72c`](https://github.com/mikyll/ROQuiz/commit/1f9d72c5b99ceb4d2552391114f4a2fffc9773af))
- chore: add devtools_options.yaml ([`e952b44`](https://github.com/mikyll/ROQuiz/commit/e952b449f1a9934b334f78db0885b35c69843195))
- chore: add questions tmp files ([`80ce987`](https://github.com/mikyll/ROQuiz/commit/80ce987df7405fcb20056266768fc87039d01570))
- fix(view_info): update openUrl ([`4f7a039`](https://github.com/mikyll/ROQuiz/commit/4f7a0398a68a1e9e3dd3576873de8a9a5b23133d))
- fix(view_menu): update constraints ([`36588bf`](https://github.com/mikyll/ROQuiz/commit/36588bfd2b74c5130ba6a58b66e3d024e8305fe3))
- fix(view_licenses): add constraints ([`fb1c125`](https://github.com/mikyll/ROQuiz/commit/fb1c125cc3eb23b397d965e57e060bb2d899ba98))

### 2025-10-10

- fix(view_quiz): remove debug timer ([`14513bf`](https://github.com/mikyll/ROQuiz/commit/14513bf97ad67ec04505e2e6089d8b20547f42cc))
- feat(view_topics): add route to view_questions ([`0b74652`](https://github.com/mikyll/ROQuiz/commit/0b74652f561ed042878893dca1b5774bec09c03f))
- feat(view_questions): add title and editable params ([`239f309`](https://github.com/mikyll/ROQuiz/commit/239f30986dd0fcb9541010a7ebd81824df802557))
- fix(view_topics): replace bottom navbar with floating action button ([`3c96d02`](https://github.com/mikyll/ROQuiz/commit/3c96d02b0637f650e06aabd192a6e297d93c132e))
- feat(view_questions): implement search ([`5051a23`](https://github.com/mikyll/ROQuiz/commit/5051a23c4613dc2cfe284fbf23a07ad0335cc4af))
- fix(widget/custom_search_bar): remove useless stuff ([`fdae651`](https://github.com/mikyll/ROQuiz/commit/fdae651a97d1cd349328adbe75771fa501a9ff47))
- fix(widget/custom_search_bar): update icon and text color ([`2eaa95a`](https://github.com/mikyll/ROQuiz/commit/2eaa95a0ba9ee6c984008dd6ca9e6fc58f6af341))
- fix(widget/constrained_appbar): workaround to remove lateral padding ([`7647b59`](https://github.com/mikyll/ROQuiz/commit/7647b59c1018fbfe203bd04cad4ab42669083e7e))
- fix(view_quiz): ugly af workaround for bottom navbar constrants ([`8a25aa3`](https://github.com/mikyll/ROQuiz/commit/8a25aa34ee3c84be423b07cc68793c968e0487c8))
- fix(widget): update constrained_appbar ([`75c0325`](https://github.com/mikyll/ROQuiz/commit/75c03252177a2f618aa634696780de06486c1550))

### 2025-10-09

- fix(views): add width constraints to floating action buttons ([`bb7d110`](https://github.com/mikyll/ROQuiz/commit/bb7d11067e1af6429ae7ada4218cafdd9f665a0d))
- fix(views): update bottombar ([`44e22d4`](https://github.com/mikyll/ROQuiz/commit/44e22d4a4ece36aa60bdcdc0177d9a79135f0eb9))
- fix(view_quiz): add constraints to bottomnavbar ([`6aa8178`](https://github.com/mikyll/ROQuiz/commit/6aa8178cd9d0541c87cd8feff0aa7bccac99af3f))
- feat(views): use constrained_appbar ([`4a1c7b4`](https://github.com/mikyll/ROQuiz/commit/4a1c7b4cc268e7dae34847d2e456bbfc46406333))
- feat(widget): add constrained appbar ([`79e48c6`](https://github.com/mikyll/ROQuiz/commit/79e48c69f8fdf8f94dfe629341358cf66590da93))

### 2025-10-08

- fix(questions): update questions.yaml - 5 new questions, style and capitalize answers ([`d7d6c24`](https://github.com/mikyll/ROQuiz/commit/d7d6c2449c4cb7aba1ca0dd3b70154a6f99f4c91))
- feat(cli): add http_test ([`8130482`](https://github.com/mikyll/ROQuiz/commit/81304825e9448d964038de26c483c4509dc6db48))
- fix(model): remove question_checker ([`5753772`](https://github.com/mikyll/ROQuiz/commit/575377228b50a2182d7829ae73c3659494b640df))
- fix(model): remove quiz_question ([`d9dd73f`](https://github.com/mikyll/ROQuiz/commit/d9dd73fda4a59004beb9078204b3054f4f0130b2))
- fix(view_questions): disable transition animation for edit ([`08dad62`](https://github.com/mikyll/ROQuiz/commit/08dad62591100f66c23e980d7d2dc7af516a1cdf))
- fix(view_menu): temp code for view_history ([`3cbe659`](https://github.com/mikyll/ROQuiz/commit/3cbe659ba34c7cb21d9529f23187bcfb1818ddf6))
- fix(view_info): handle URL with no animation ([`c789553`](https://github.com/mikyll/ROQuiz/commit/c7895534fb3bf0c616701fa59a14db979924298a))
- feat(view): add view_history_quiz draft ([`fd33298`](https://github.com/mikyll/ROQuiz/commit/fd332981f4d4d7f42712995edc3ac3e8e13da393))
- chore: update pubspec.yaml ([`2745cc5`](https://github.com/mikyll/ROQuiz/commit/2745cc5818a86c2a4a79b652789f930e644b8283))
- test: commented temporary test file ([`0d54f6e`](https://github.com/mikyll/ROQuiz/commit/0d54f6e7bfe04ef18ceb4ae0ebdfe4b0dbc74c34))
- feat(widget): menu_button draft ([`b1486bc`](https://github.com/mikyll/ROQuiz/commit/b1486bc44991ffa2606f71e0219dc316255a9ef2))
- docs: update README.md ([`da3c8c7`](https://github.com/mikyll/ROQuiz/commit/da3c8c7b293b94f8857394afae659531b7a18ba2))

### 2025-08-17

- fix(settings): add comment for auto generation ([`cb0d9e8`](https://github.com/mikyll/ROQuiz/commit/cb0d9e8af97d20b112449474f45c98c5eb18b0fd))
- fix(utils): add default value in getGradeString ([`5909ea1`](https://github.com/mikyll/ROQuiz/commit/5909ea12baf9521d215f1e30a66275a3399deb63))
- feat(view_history) ([`8cc3b15`](https://github.com/mikyll/ROQuiz/commit/8cc3b15b4bf87b5077e64bcd8723f7b52c0fc3d8))
- fix(view_questions_edit_file): change export icon ([`c6794a5`](https://github.com/mikyll/ROQuiz/commit/c6794a5bb6ec32a12dbfdc9ccc2093fc872c63a3))
- fix(view_topics): decrease padding ([`fc67943`](https://github.com/mikyll/ROQuiz/commit/fc67943c6971f6f537ad79a4460be141429f6255))
- fix(grade): use getGradeString from utils ([`12a2a69`](https://github.com/mikyll/ROQuiz/commit/12a2a692187f342aa90d814f6fb629123700d4d8))
- fix(result_card): show range if written grade not set ([`fb86881`](https://github.com/mikyll/ROQuiz/commit/fb86881ceff6141ca425905ece550a73d7da0299))
- fix(star_button): no grow when animate is false ([`45f7225`](https://github.com/mikyll/ROQuiz/commit/45f72256361d1812841f78248cf47f6d91a29c48))

### 2025-08-06

- fix(view_topics): rename params ([`84b6326`](https://github.com/mikyll/ROQuiz/commit/84b6326afd94b3bc163d70a4768e48cabcf2ba26))
- fix(question_card): add params ([`6cadf69`](https://github.com/mikyll/ROQuiz/commit/6cadf695c1ea2e7dddcbee5762cbf3f0a5f69c32))
- fix(main): remove settings param ([`4893b1c`](https://github.com/mikyll/ROQuiz/commit/4893b1c0f44926ae90dcfc23523249081d5fdd5b))
- fix(settings): add hideCorrectAnswersInEditMode and rename quizPool ([`9e08913`](https://github.com/mikyll/ROQuiz/commit/9e089130985cd43785a1b0f95ad38fb550a375e9))
- fix(view_menu): use settings provider and cleanup ([`1dfbf3b`](https://github.com/mikyll/ROQuiz/commit/1dfbf3b5059f514e020fd7dd155bacca3119c853))
- fix(view_questions): adjust navigation + buttons ([`7e899b6`](https://github.com/mikyll/ROQuiz/commit/7e899b613b8b187490d056ff5bb963f5729fe700))
- fix(view_questions_edit): remove sizedBoxes ([`4f22a2e`](https://github.com/mikyll/ROQuiz/commit/4f22a2e65d02de8e015b82b7cd3005646f97ca91))
- feat(view): create view_questions_edit_file ([`8e8a226`](https://github.com/mikyll/ROQuiz/commit/8e8a22618c4cf8fa963b947889fb68c63a1b4e96))
- fix(view_quiz): lot of stuff ([`7e3d464`](https://github.com/mikyll/ROQuiz/commit/7e3d464a39f58283e214c42e4d0979a3315b0d4d))
- feat(utils): move utils functions ([`941f9f2`](https://github.com/mikyll/ROQuiz/commit/941f9f27e47ff96d0b674bbb63327ede20961113))
- fix(view_settings): add show/hide correct answer ([`7c336a0`](https://github.com/mikyll/ROQuiz/commit/7c336a00b8cb9b082a00726811636d4ebd6b3089))
- feat(widget): create result_card ([`c86cf4b`](https://github.com/mikyll/ROQuiz/commit/c86cf4be553c27838c23c5131fbce26fab104da3))
- fix(setting_entry): adjust size ([`55df991`](https://github.com/mikyll/ROQuiz/commit/55df9913900de44323aa1fb24ff2aa5d01f7e716))
- fix(view_info): handle no animations ([`d64660e`](https://github.com/mikyll/ROQuiz/commit/d64660e2926ded1fbfba09aa897085656097963e))
- fix(grade): handle no animations ([`513dcbf`](https://github.com/mikyll/ROQuiz/commit/513dcbfe1a344c2b29923e8e748301b6dacac1a4))
- fix(star_button): handle no animations ([`c352040`](https://github.com/mikyll/ROQuiz/commit/c352040d0993094440d5a7dff9734c19e8757530))

### 2025-08-05

- fix(view_quiz): remove import result_card ([`e452e98`](https://github.com/mikyll/ROQuiz/commit/e452e98b6c0390ac3b903602b06762b2fd72acce))
- fix(view_info): add constrained box ([`07a3c51`](https://github.com/mikyll/ROQuiz/commit/07a3c51971051c48028cb7fdf2dbbc31d4bb1220))
- fix(question_dialog): use row to center text ([`55cf1f2`](https://github.com/mikyll/ROQuiz/commit/55cf1f2af825664e98fb8d1b0361c750600d371d))
- fix(question_card): add comment ([`e051e0e`](https://github.com/mikyll/ROQuiz/commit/e051e0e109e2582e73c8588244087262f15adbf0))
- fix(grade): remove print in grade widget ([`878c941`](https://github.com/mikyll/ROQuiz/commit/878c94143629627b9a75d26c6410e071e51d4d9a))
- fix(view_topics): small update for top banner ([`04909c5`](https://github.com/mikyll/ROQuiz/commit/04909c53e07595dc5cbd2e8d5b5b99d676d40b6d))
- feat(view_settings): working stuff ([`1f410ee`](https://github.com/mikyll/ROQuiz/commit/1f410eeee175527c5775ad0e8f0a1770ed4ddbe1))
- fix(view_quiz): change written grade + animations ([`c80e728`](https://github.com/mikyll/ROQuiz/commit/c80e728b273aae3b97a92eb7f224a54f3ab14b1d))
- fix(view_menu): integrate settings ([`0b90f2a`](https://github.com/mikyll/ROQuiz/commit/0b90f2a66cc124446c9f59d7181476d0f5fbef57))
- style(themes): update IconButton theme ([`da44680`](https://github.com/mikyll/ROQuiz/commit/da44680a4a23310dc08b95ac0d38a3057b862843))
- fix(model): update question_repository ([`80987f2`](https://github.com/mikyll/ROQuiz/commit/80987f22ee2810f953deb3341df967664613b79c))
- fix: main ([`4480dfe`](https://github.com/mikyll/ROQuiz/commit/4480dfe93edd079bceff7d5a298e4176647a8f3d))
- feat(model): add settings_manager ([`9c58dbc`](https://github.com/mikyll/ROQuiz/commit/9c58dbcc637e14bfd24ae09b41e7dfea362887b9))
- feat(model): add settings class ([`48b0cce`](https://github.com/mikyll/ROQuiz/commit/48b0cce56566da74d31876d43a09a2b33398fba6))
- chore(pubspec): add dependencies for json ([`80f7ebe`](https://github.com/mikyll/ROQuiz/commit/80f7ebeb392636b292369a8de32eb787d2568b23))
- docs: update README.md ([`9f357c6`](https://github.com/mikyll/ROQuiz/commit/9f357c68b9997abcb70178be9402434ce2fb3d64))

### 2025-08-04

- feat(widget): added grade widget ([`1a01618`](https://github.com/mikyll/ROQuiz/commit/1a01618656329dfa861914f5517a027713822504))

### 2025-08-02

- fix(question_card): selectable and add iQuestion ([`bb2aaef`](https://github.com/mikyll/ROQuiz/commit/bb2aaef3e789b103a8b8ebe3797033d286221ad9))
- feat(widget): add hidden_text ([`f218ed0`](https://github.com/mikyll/ROQuiz/commit/f218ed04188a147cdac59c204c4effbd6b861e88))

### 2025-07-31

- fix(view): use separator in question lists ([`2e80d9e`](https://github.com/mikyll/ROQuiz/commit/2e80d9e6ad618e46029141e7633918a6c474ec91))
- feat(view): add view_settings mock ([`42a6396`](https://github.com/mikyll/ROQuiz/commit/42a63965993322661caef47b0dd63b83f60e1eeb))
- feat(widget): add setting_entry ([`797f41f`](https://github.com/mikyll/ROQuiz/commit/797f41fd1a7c9cf8e1ddabc9776690dd456598b5))
- feat(widget): add separator ([`e49c0d7`](https://github.com/mikyll/ROQuiz/commit/e49c0d73712c7beb5b8ede0d8850279f53423f22))

### 2025-07-30

- fix(model): make id nullable ([`3095e80`](https://github.com/mikyll/ROQuiz/commit/3095e80e136f0690c63708c08191bc5cd81edf9d))
- fix(view): handle edit in view_questions_edit ([`03efabf`](https://github.com/mikyll/ROQuiz/commit/03efabf855790e79dc2190d5a8bc80d1c8d9a478))
- fix(widget): add edit mode in question_dialog ([`a508667`](https://github.com/mikyll/ROQuiz/commit/a508667a58582cdd1dd1742baf1667e2acdb7c78))
- fix(view): update view_questions_edit ([`f7332a0`](https://github.com/mikyll/ROQuiz/commit/f7332a09f6b1afdee9f81cd122b87f40eb8d9879))
- feat(widget): create question_dialog ([`57f73c7`](https://github.com/mikyll/ROQuiz/commit/57f73c7e63526a45ad2d7cf702ff9cfaec1f4052))
- fix(view_info): adjust description line height ([`277c0d7`](https://github.com/mikyll/ROQuiz/commit/277c0d79509e75947e0f3a91ef7c45dffec4b230))
- feat(model): add classes for command pattern ([`cd4ca2c`](https://github.com/mikyll/ROQuiz/commit/cd4ca2c1197473b3ce4caf21854b36fececcef8e))

### 2025-07-29

- chore: add http dependency ([`8cc4189`](https://github.com/mikyll/ROQuiz/commit/8cc4189c349b37a47cf18738a0658e619f7cf366))
- feat(cli): add contributors CLI utility ([`940fcf1`](https://github.com/mikyll/ROQuiz/commit/940fcf100b35ec4f79e2e3e07194ffddc6fd3a02))
- fix(view_quiz): help button ([`a357bad`](https://github.com/mikyll/ROQuiz/commit/a357bad794e2b40fe13dfb53ba418a730036c2fa))
- fix(view_menu): buttons ([`e8aa77a`](https://github.com/mikyll/ROQuiz/commit/e8aa77a72279905cfd3cf0607f46b1b5c39746e0))

### 2025-07-28

- debug(view_menu): show error box border ([`dceafbf`](https://github.com/mikyll/ROQuiz/commit/dceafbfabf13ce4f241cb778d055148ec2d3e927))
- style(question_card): remove useless comments ([`beab9ad`](https://github.com/mikyll/ROQuiz/commit/beab9ad5dc4ca1267c055c62fad31fd2397633fa))
- fix(view_quiz): nicer results card ([`8fd3c0d`](https://github.com/mikyll/ROQuiz/commit/8fd3c0dc30565fec8f979c4dc14068a334ebca63))

### 2025-07-27

- fix(view_menu): move buttons ([`44c0079`](https://github.com/mikyll/ROQuiz/commit/44c0079dc4c934b386718c67048a4e6ec8b4dfe6))
- fix(view_quiz): optimize confetti ([`7bbc3e1`](https://github.com/mikyll/ROQuiz/commit/7bbc3e19e2dac680e709dffc86664097da5cd271))

### 2025-07-26

- feat(view_quiz): add confetti animation ([`3277c37`](https://github.com/mikyll/ROQuiz/commit/3277c37559db3a3365d088684934ab06580f098f))
- fix(view_info): update text style ([`5a76ba9`](https://github.com/mikyll/ROQuiz/commit/5a76ba93a7f4e040edb9fd20a6e211b8284c3378))
- fix(view_menu): update text style ([`776622c`](https://github.com/mikyll/ROQuiz/commit/776622c2c657d744214841396b3921a6f6b9c6c0))
- fix(style): update themes ([`cf0068e`](https://github.com/mikyll/ROQuiz/commit/cf0068efef6bb90cd013c8fe201155da07298e99))
- fix(cli): add nullable topic in question parser ([`da99baa`](https://github.com/mikyll/ROQuiz/commit/da99baad4d544ef2515e7aefb63041752b5e6664))

### 2025-07-23

- fix(view_quiz): update grade management ([`96adf67`](https://github.com/mikyll/ROQuiz/commit/96adf678b31530d5d324e8bce5b89609c845264b))
- fix(view_quiz): vote calcs, form field, validation ([`c7e73e4`](https://github.com/mikyll/ROQuiz/commit/c7e73e4967e403aa12137cd7492fb671308489c4))
- fix(model): update quiz ([`c1f533f`](https://github.com/mikyll/ROQuiz/commit/c1f533fed9cf92c83fbd91a4e0186465af7a2e5e))

### 2025-07-22

- fix(views): adjust navbar icon size and horizontal constraints ([`c5606a7`](https://github.com/mikyll/ROQuiz/commit/c5606a735f0697fd25b85876266909e59b018e6b))
- fix(view_quiz): adjust padding and let timer reach 0 ([`e6da539`](https://github.com/mikyll/ROQuiz/commit/e6da539c7816af86a277d6a06ce60c6110777ee1))
- fix(question_card): text style ([`cea1ca4`](https://github.com/mikyll/ROQuiz/commit/cea1ca41185d46753ec50ef9107fc55459f6480c))

### 2025-07-21

- fix(question_card): optimize ([`89fb598`](https://github.com/mikyll/ROQuiz/commit/89fb5981e1789591ae98928754faa607f66e57a0))
- fix(palettes): rename ([`687e585`](https://github.com/mikyll/ROQuiz/commit/687e585d4a218660657edaf5389526ddda93edf3))
- fix(themes): rename ([`a64b0ef`](https://github.com/mikyll/ROQuiz/commit/a64b0ef16e9130cb94b87ce9007f5d404306cba7))
- fix(view_info): update description ([`8508fbc`](https://github.com/mikyll/ROQuiz/commit/8508fbc0eca8c7a131342c9b78e45a08141ee161))
- fix(view_menu): add route to view questions ([`0eefde7`](https://github.com/mikyll/ROQuiz/commit/0eefde73e42957cb4c19c21bf817d924e61f0b70))
- fix(view_questions): add search bar, center ([`f885db6`](https://github.com/mikyll/ROQuiz/commit/f885db69411316f691a3e5d82c08adf936d6605b))
- feat: add view_questions_edit ([`312a204`](https://github.com/mikyll/ROQuiz/commit/312a204c98114d7e7d99ec3b84269f6e9158e4b2))
- fix(view_quiz): add hours counter, center ([`fe7ba18`](https://github.com/mikyll/ROQuiz/commit/fe7ba183f109de16c5e7e84a8c37ad55b3ac53ec))
- fix(view_topics): centered ([`a49d4e7`](https://github.com/mikyll/ROQuiz/commit/a49d4e7dd071813e43463f9296014575fdbb7ea5))
- feat: add custom_search_bar widget ([`9936fd8`](https://github.com/mikyll/ROQuiz/commit/9936fd8b14e8a03b8a8c14fa9c21aedcc58faf23))
- fix(question_card): selectable card ([`f474282`](https://github.com/mikyll/ROQuiz/commit/f474282278c17141108b604b21b0403fc05bdc9a))
- style(star_button): code layout ([`5c38c70`](https://github.com/mikyll/ROQuiz/commit/5c38c70f84a045849238a6a2eec1be22e93f2486))

### 2025-07-17

- fix(view): use new question card ([`9747f16`](https://github.com/mikyll/ROQuiz/commit/9747f16fe6008a1609dfa274cb5cbda400c863cc))
- fix(widget): question_card with different modes ([`a548321`](https://github.com/mikyll/ROQuiz/commit/a548321153de7ab2a93cd1917045514b0e31eac9))
- fix: update question_card widget ([`42c3859`](https://github.com/mikyll/ROQuiz/commit/42c385933b0e21e7bb96b00840da1b7a4671a9bd))
- feat: add view_questions ([`bc0228d`](https://github.com/mikyll/ROQuiz/commit/bc0228d28cc630fd0841d8635a445a12edb990fb))
- chore: add shared_preferences dependency ([`cdac1eb`](https://github.com/mikyll/ROQuiz/commit/cdac1eb4b08b7a82afe17e99b46426e38b9f1ad9))

### 2025-07-16

- style: update themes ([`724f079`](https://github.com/mikyll/ROQuiz/commit/724f0790261919a2df9b83e23b12dae5c7d93b22))
- feat: add view_topics ([`d53ff58`](https://github.com/mikyll/ROQuiz/commit/d53ff58b9857ce88ec1c3fe55d6fce7d51126b01))
- fix(view_menu): add safearea and continue refactor ([`96b92e3`](https://github.com/mikyll/ROQuiz/commit/96b92e345d9a729a0f4b96eff2ef7b51c5134bd9))
- fix(view_quiz): use named parameters for quiz ([`f5bc9e2`](https://github.com/mikyll/ROQuiz/commit/f5bc9e297a35b2ce5c347ebb3e851401bb299d75))
- test: update to named parameters ([`3dbacc1`](https://github.com/mikyll/ROQuiz/commit/3dbacc15b82599838fda56b5fa689b70b818c78e))
- refactor: use named parameters in question/quiz ([`88bbc9a`](https://github.com/mikyll/ROQuiz/commit/88bbc9ad09ebd5716111cd8f173b27b19f6c0290))
- fix(view_info): link view_licenses ([`c89c439`](https://github.com/mikyll/ROQuiz/commit/c89c4391d3638176d14aa941096a00ec5c0fdd90))
- feat: add licenses stuff ([`e495209`](https://github.com/mikyll/ROQuiz/commit/e4952092b5ab28eee9e8d4b692867e3c76b84934))

### 2025-07-15

- fix(view_quiz): adjust new question widgets ([`6159968`](https://github.com/mikyll/ROQuiz/commit/615996866d2e91fafdb42b94262b01cd9e1597d6))
- fix(question_card): separate widgets ([`cec0c7f`](https://github.com/mikyll/ROQuiz/commit/cec0c7f8a7d16de4f4ff3a0904f7aa69f46e3c0f))
- fix(view_info): update app description/disclaimer ([`b59bece`](https://github.com/mikyll/ROQuiz/commit/b59beceba38433208345a2a424d47e6737248532))
- feat(questions_parser): add inferQuestionFormat() ([`a033333`](https://github.com/mikyll/ROQuiz/commit/a033333efa09cff38b083e2704f6676dd0a8f191))

### 2025-07-14

- fix: update questions format ([`5eb2847`](https://github.com/mikyll/ROQuiz/commit/5eb28479a09a4e27ddcfcb9143b90dadf85d48a2))

### 2025-07-13

- fix(style): update rename star button theme ([`c1fb291`](https://github.com/mikyll/ROQuiz/commit/c1fb29118850718a763df482f366dbe6232aa879))
- fix(model): quiz ([`f6d8fd2`](https://github.com/mikyll/ROQuiz/commit/f6d8fd28f8cb7a1101ff20458741d6c33a0602d9))
- fix: small fix in question repo ([`5ca0161`](https://github.com/mikyll/ROQuiz/commit/5ca01618ea2357e91dc642c175717d08d0eafcf3))
- fix: update navigation and palettes ([`82f2189`](https://github.com/mikyll/ROQuiz/commit/82f2189b48cedea6187aa6d723f32d38275e6663))
- chore: add url_launcher dependency ([`270f1fe`](https://github.com/mikyll/ROQuiz/commit/270f1fe2dd78737f1dfddcfbd3a70be2f6391071))
- fix(view_info): update description and star button ([`44b10d0`](https://github.com/mikyll/ROQuiz/commit/44b10d0d8cb7c409ddefdb511b13da3de20fd0a6))
- fix(star_button): shrink the button after reaching max size ([`38f8bef`](https://github.com/mikyll/ROQuiz/commit/38f8bef105a21ccc8ff2c2c0aeda383075073347))
- feat: created question_card ([`133da44`](https://github.com/mikyll/ROQuiz/commit/133da44db8590d584d0fb302770839fc2915dc0d))
- fix(star_button): adjust fade ([`6500e44`](https://github.com/mikyll/ROQuiz/commit/6500e4414fbd438d5a16e7cf341a9a9230a49e5e))
- feat(widget): new star_button widget ([`f1b9cfa`](https://github.com/mikyll/ROQuiz/commit/f1b9cfa2cd0e6225bc6eb704e1e8a50932e4345c))

### 2025-07-11

- fix(question_parser): add num of already present questions in topics exception ([`7654556`](https://github.com/mikyll/ROQuiz/commit/7654556675f5e29391576cd16639d59131047bc8))
- style(question_parser): add single quotes in exceptions ([`2783c4b`](https://github.com/mikyll/ROQuiz/commit/2783c4b5a1569fc01be0794337084f79552b3bc1))
- fix(question_parser): check answer letter ([`a681102`](https://github.com/mikyll/ROQuiz/commit/a681102465f5b4deaf97565dd178cfa449b7ff22))

### 2025-07-10

- refactor: some mixed stuff ([`924be38`](https://github.com/mikyll/ROQuiz/commit/924be38340794a7f135bd7bb9f0ed540395b12fe))
- feat: add new questions asset ([`1bb0446`](https://github.com/mikyll/ROQuiz/commit/1bb04466aee98860b4c326e8643a9ee5c314ec70))
- fix: question parser ([`ddcfeb7`](https://github.com/mikyll/ROQuiz/commit/ddcfeb713c528a687be53e644715857d26986d7d))

### 2025-07-08

- fix: question.toYaml() ([`c52f25c`](https://github.com/mikyll/ROQuiz/commit/c52f25c10b33493b5c656ad58f8ba2ec38de956f))
- test: update unit tests ([`07bb3c9`](https://github.com/mikyll/ROQuiz/commit/07bb3c98ad86239e403d78bdff75302a933763a6))
- chore: update pubspec.yaml ([`ed5dfb8`](https://github.com/mikyll/ROQuiz/commit/ed5dfb8e065d22dcb1db2fb2f1207ec2f4db6814))
- refactor: fix toString and toYaml in question ([`d4e747d`](https://github.com/mikyll/ROQuiz/commit/d4e747dadb488d1644ba5082e2409daf8b9c27b7))
- refactor: question_parser ([`fdf4e69`](https://github.com/mikyll/ROQuiz/commit/fdf4e698379d81ab7e042e9009e4b2438377f6de))
- refactor: question class ([`db372b3`](https://github.com/mikyll/ROQuiz/commit/db372b3fd4582268fb04fb0b2514786f63185481))

### 2025-07-06

- fix: test base app ([`6bf8854`](https://github.com/mikyll/ROQuiz/commit/6bf88549f7122f2b3b16e05936b6befaa4aa716d))
- fix: add asset ([`edf0cf8`](https://github.com/mikyll/ROQuiz/commit/edf0cf8470d76bb380109608d43cd5f2ca2747e7))

### 2025-07-05

- chore: add flutter version ([`bce10a0`](https://github.com/mikyll/ROQuiz/commit/bce10a0fa37f646e2f94fd7f81ed8ac9bca61f09))
- ci: move .github directory ([`27b6597`](https://github.com/mikyll/ROQuiz/commit/27b6597012607202308ec44ef6bb947f2c6c66f3))
- ci: update test command ([`4751fba`](https://github.com/mikyll/ROQuiz/commit/4751fbae6f120ab289cf8fd3e0c1d343dcccd3aa))
- ci: test ([`1195867`](https://github.com/mikyll/ROQuiz/commit/1195867d964089932990ab9476c0507e10afdf33))
- feat: base structure ([`a3a484b`](https://github.com/mikyll/ROQuiz/commit/a3a484b2d72875c56acebe54c841c1867edb6a31))

## [1.11.5] - 2025-07-23

### 2025-07-23

- fix(credits): add VaiTon to contributors ([`036cece`](https://github.com/mikyll/ROQuiz/commit/036ceceee73517cf7989e99c9f8a18c8cd055d5c))
- update README.md ([`d3a6c51`](https://github.com/mikyll/ROQuiz/commit/d3a6c51173df839adb9f82a34247f782ed26f33e))
- chore: bump version to v.1.11.5 ([`b004230`](https://github.com/mikyll/ROQuiz/commit/b004230cc320d2add13e03f09af191e41111070d))
- update README.md ([`ad859aa`](https://github.com/mikyll/ROQuiz/commit/ad859aa21f21bb199912f1cefa83a8db5ff699f5))

### 2025-07-22

- update README.md ([`92b5c22`](https://github.com/mikyll/ROQuiz/commit/92b5c2252b044fab096a11999605c50c725745b5))

### 2025-07-13

- fix: update HTML structure and meta tags in index.html ([`6b54f4a`](https://github.com/mikyll/ROQuiz/commit/6b54f4a314b72565a1d7213ae50c7002513b0b98))
- fix: update constructors to use 'super.key' ([`96f0591`](https://github.com/mikyll/ROQuiz/commit/96f0591a961cf2f16a1f9e3e37aa421bfbf137d5))
- fix: quiz grade calculation ([`a998e3d`](https://github.com/mikyll/ROQuiz/commit/a998e3d7035708b9ec8ef770130ee3fc61a5a0fd))

### 2025-07-11

- chore: revert .gitignore for any build platform ([`280f1f0`](https://github.com/mikyll/ROQuiz/commit/280f1f037165c7872d0690e1e43902f4bcffea2d))
- fix: remove web build ([`6e5b717`](https://github.com/mikyll/ROQuiz/commit/6e5b7173a9b3751f2a94996efe6ceb6256bbfd0d))
- docs: update README ([`9497119`](https://github.com/mikyll/ROQuiz/commit/94971191477fc055e029b3e77e8a3ce3dc345d8d))
- ci(deploy_to_gh_pages): update deploy base href ([`d0c59bb`](https://github.com/mikyll/ROQuiz/commit/d0c59bb8ad88135bf918f7c295c8e4670b446f07))
- ci(deploy_to_gh_pages): change dir of upload-pages-artifact ([`cb9790e`](https://github.com/mikyll/ROQuiz/commit/cb9790edf29e251ad0165be38220af51086076e9))
- ci(deploy_to_gh_pages): update working dir ([`a7ebc44`](https://github.com/mikyll/ROQuiz/commit/a7ebc44c70cd262908bfcb9385161bd33c479a4b))
- ci(deploy_to_gh_pages): add working dir ([`d1bc44b`](https://github.com/mikyll/ROQuiz/commit/d1bc44b6967205ae83180852a724ad767a735c26))
- ci: create deploy_to_gh_pages.yml ([`ec37577`](https://github.com/mikyll/ROQuiz/commit/ec3757753fa14b3989b531debef204721d0a4aa7))
- feat: web build ([`a865c85`](https://github.com/mikyll/ROQuiz/commit/a865c8579db9350fc9f0c13a2eed290cf1b9c1de))
- docs: update app-mobile README ([`cc64abb`](https://github.com/mikyll/ROQuiz/commit/cc64abbbe13826addbb2d1e09e86b1788d8ac484))
- fix: update question date ([`d4ac6ec`](https://github.com/mikyll/ROQuiz/commit/d4ac6ecc3268b4e56cf434b503cad0c4fd0b1c75))

## [1.11.4] - 2025-07-02

### 2025-07-02

- fix: update platforms ([`9f767ed`](https://github.com/mikyll/ROQuiz/commit/9f767ede3c13d799ed2c75f476cb02e44c31e6b2))
- fix: android app label ([`f1270dc`](https://github.com/mikyll/ROQuiz/commit/f1270dcaaf0e1b0d2c32c41890e72df6b281bb08))
- fix: android permissions ([`c5ef4ba`](https://github.com/mikyll/ROQuiz/commit/c5ef4bacdc5dcb539e35230ffa5b442f00918e98))
- fix: AppUpdater bug ([`94b9335`](https://github.com/mikyll/ROQuiz/commit/94b93354632717beff1948db4d65b87b1fc978fd))

### 2025-07-01

- ci: update commit messages ([`a8492e0`](https://github.com/mikyll/ROQuiz/commit/a8492e09e2975c0fe7e2c7f42620edc3a922225f))
- fix: update credits ([`5d34286`](https://github.com/mikyll/ROQuiz/commit/5d342862921c733775f3b046ce1a9d9619cf3fd7))
- update README.md ([`4446c81`](https://github.com/mikyll/ROQuiz/commit/4446c81501c7ca9d53000c4d29f90ddc39cd9514))
- fix: android platform ([`6e188e4`](https://github.com/mikyll/ROQuiz/commit/6e188e4c8640a3c5672bab1012cd9ecef70ae357))
- chore: bump app version in pubspec.yaml ([`10a741f`](https://github.com/mikyll/ROQuiz/commit/10a741f1d1552bd587cc8cbbdd9d5211d140e682))
- fix: null handling in grade calculation ([`9513055`](https://github.com/mikyll/ROQuiz/commit/9513055fa5ea04bab6556cd417041cba65e788c2))

### 2025-06-30

- update README.md ([`b510f2e`](https://github.com/mikyll/ROQuiz/commit/b510f2eea5c3594f28d37bfa19d8b7d858bff2e2))
- style: change all CRLF to LF ([`fac4f96`](https://github.com/mikyll/ROQuiz/commit/fac4f96e6b01771d2096d06be059b492db6ebaa2))
- Update README.md ([`c973068`](https://github.com/mikyll/ROQuiz/commit/c973068520893b205036f93c4df2f434e854887c))
- ci: fix github token ([`4a5b3e0`](https://github.com/mikyll/ROQuiz/commit/4a5b3e0801a4b518d1a1f7ea436f97ecc033461d))
- update README.md ([`7c5ed0c`](https://github.com/mikyll/ROQuiz/commit/7c5ed0ce4bc2afaf2534d243bd702735e36f65c5))
- ci: update actions/checkout to v4 ([`2835b09`](https://github.com/mikyll/ROQuiz/commit/2835b095606079dfa1fdb3b5be7f42d76b663336))
- update README.md ([`8bfc31a`](https://github.com/mikyll/ROQuiz/commit/8bfc31abb0d198d7df75aa5d509bc63adb9e8899))
- Update file domande ([`7aae981`](https://github.com/mikyll/ROQuiz/commit/7aae9810f0a41ce2a6bdd39293d51e3c36e95ead))
- fix: ViewQuiz ([`f24d329`](https://github.com/mikyll/ROQuiz/commit/f24d32962aaf0abb868e0f43a6acad80cabbd8a3))
- fix: revert .project in app-desktop ([`7ca2783`](https://github.com/mikyll/ROQuiz/commit/7ca2783cad54c746cac8c5d3a02bb044ad9828fa))
- fix: credits.json ([`6b02426`](https://github.com/mikyll/ROQuiz/commit/6b02426435263e2577f7a04b3abccbc63143f336))
- fix: file Domande ([`d078e0e`](https://github.com/mikyll/ROQuiz/commit/d078e0ef5e9a4611c20f08f6e1f16390d5b66213))
- review ([`9ec512f`](https://github.com/mikyll/ROQuiz/commit/9ec512fd8a4888a344228362e4ec9ac5dccbf1a1))

### 2025-06-25

- fix: errore calcolo media ([`d69d9e8`](https://github.com/mikyll/ROQuiz/commit/d69d9e84c0ec827dbfea6c19086591f981085f8c))

### 2025-06-24

- feat: aggiunta possibilità di calcolare voto definitivo ([`07a9466`](https://github.com/mikyll/ROQuiz/commit/07a9466024b336fdc28bd2a71ef40451fb8306af))

### 2025-01-17

- Update file domande ([`3c2470e`](https://github.com/mikyll/ROQuiz/commit/3c2470ebb030794d95373d300941dfc3827b9fff))
- Update README.md ([`935a0e4`](https://github.com/mikyll/ROQuiz/commit/935a0e45f4795e674f089cb11601075a41d2d103))
- hotfix: aggiustamento file domande (pre-refactor) ([`0e8b571`](https://github.com/mikyll/ROQuiz/commit/0e8b571702579567faeadbe4435baede5f355da9))

### 2025-01-16

- update README.md ([`53cbeab`](https://github.com/mikyll/ROQuiz/commit/53cbeab5f4ea516b88656e34006fa54392262c4b))
- ci: update contributors workflow ([`d927867`](https://github.com/mikyll/ROQuiz/commit/d9278677afb31451663f6838ebf253425626d590))
- Update README.md ([`5ae3ab9`](https://github.com/mikyll/ROQuiz/commit/5ae3ab94a7e0c1ecf55c0022b900ad985c60cca3))
- Update file domande ([`fdaa488`](https://github.com/mikyll/ROQuiz/commit/fdaa488d76498c9bf069ce6d04bb7e6c950000b4))
- Update Domande.txt ([`d29f093`](https://github.com/mikyll/ROQuiz/commit/d29f0937d55ba5c872fca015034cba6275e15ac1))

### 2025-01-15

- chore: upgrade dependencies ([`89fffd8`](https://github.com/mikyll/ROQuiz/commit/89fffd85ff5e187ac293a4a25b801f3d850d4f00))
- fix: new question form template ([`b4326b7`](https://github.com/mikyll/ROQuiz/commit/b4326b752ea300e96d9964fd399d2753e73d318d))
- feat: new issue form template ([`9ef0747`](https://github.com/mikyll/ROQuiz/commit/9ef074729789f64a4433ec5ddeca51b4a9aa304d))

### 2024-11-28

- docs: update README ([`6950876`](https://github.com/mikyll/ROQuiz/commit/695087633b808234c8d89c0c69e0abd3a5441e35))

### 2024-11-26

- Update README.md ([`76d2ace`](https://github.com/mikyll/ROQuiz/commit/76d2acecfc6e35ee78634a839316316808f0d411))

### 2024-11-13

- feat: web support ([`4b2d7c9`](https://github.com/mikyll/ROQuiz/commit/4b2d7c92992bf5840a10b9ea6a55e9dd91824ed3))
- chore: bump app version to 1.11.3 ([`8246b2e`](https://github.com/mikyll/ROQuiz/commit/8246b2e14818d8f45dab14d687d8b30eab2adb65))
- fix: do not disable timer text input when max_topics is set ([`fe1847d`](https://github.com/mikyll/ROQuiz/commit/fe1847dc335770c6e7c739a8c82fc4c26236ba16))
- fix: disable edit button when checking for updates ([`a9ba677`](https://github.com/mikyll/ROQuiz/commit/a9ba6774764ca7c49d06690345d1507bd1a33563))
- fix: add fake empty logo ([`53ca851`](https://github.com/mikyll/ROQuiz/commit/53ca851ea260ce1c7b1a59895a1929a70636fd53))
- chore: bump app version to 1.11.0 ([`daaeb8f`](https://github.com/mikyll/ROQuiz/commit/daaeb8fce0e7d12e8a58987195e7cfdda9e94649))
- feat: max per topic setting ([`abf83d2`](https://github.com/mikyll/ROQuiz/commit/abf83d2431466458cb252422bbf51f5dd341607d))
- fix: compare app version ([`a80e453`](https://github.com/mikyll/ROQuiz/commit/a80e45368485eb322c9573934ac5da73716a9188))

### 2024-06-07

- Update README.md ([`a56ecc1`](https://github.com/mikyll/ROQuiz/commit/a56ecc18df9f2b9749b5e70417d7e29da2c9c25e))
- Create CONTRIBUTING.md ([`507456e`](https://github.com/mikyll/ROQuiz/commit/507456eeef87bd6c9016a6bf21c35caba06cda01))

### 2024-03-04

- Update Project Setup.md ([`f5b3444`](https://github.com/mikyll/ROQuiz/commit/f5b3444a1d8710b94521f5d443591cced3290bd0))

### 2024-02-04

- Update ViewMenu.dart ([`3df4dcf`](https://github.com/mikyll/ROQuiz/commit/3df4dcfb4d7d0a233b77c6dff28b920775502205))

## [1.10.1] - 2024-01-18

### 2024-01-18

- update ([`1f6b390`](https://github.com/mikyll/ROQuiz/commit/1f6b390a59277cfda53989a5d6b98476ff2b1be6))
- update ([`242b9b2`](https://github.com/mikyll/ROQuiz/commit/242b9b2e3fca48289a466694ae1949bdc3d042c7))

### 2024-01-14

- Update README.md ([`8f7dc89`](https://github.com/mikyll/ROQuiz/commit/8f7dc8948df1b39d49167da4941b345e37565129))
- Update README.md ([`e18f79d`](https://github.com/mikyll/ROQuiz/commit/e18f79dd2c370087eab96dcf86e68035578845f7))

### 2024-01-13

- update theme ([`aee4024`](https://github.com/mikyll/ROQuiz/commit/aee40245bdd367fa0c577639b754872060bed10c))

### 2024-01-07

- Fix ViewTopics e topics_widget.dart ([`becadf3`](https://github.com/mikyll/ROQuiz/commit/becadf3f7582afe34e70cab1c26b7d1c196e67b1))

### 2023-12-31

- Update README.md ([`bc2f2c5`](https://github.com/mikyll/ROQuiz/commit/bc2f2c51c3fd52c175003dc002c97b4d9e41b52e))

### 2023-12-22

- update ([`d9f573b`](https://github.com/mikyll/ROQuiz/commit/d9f573bcda17e7cbcc9581aab9151fa49a9e6be2))

## [1.10] - 2023-12-17

### 2023-12-17

- Update README.md ([`10cc211`](https://github.com/mikyll/ROQuiz/commit/10cc2110748d4761fb85f8aaff053aa611f1920a))
- update ViewSettings ([`3f8825d`](https://github.com/mikyll/ROQuiz/commit/3f8825d1e97dccf103f7833eb61383470670ee4b))

## [1.9.0] - 2023-12-16

### 2023-12-16

- update ViewSettings ([`fcd6733`](https://github.com/mikyll/ROQuiz/commit/fcd673372ffb0d8d6c84ba43f0489a69780c8d32))
- Update ViewQuiz.dart ([`90b37ff`](https://github.com/mikyll/ROQuiz/commit/90b37ff882d54313e2863e25bf22b5915a94a972))

### 2023-12-09

- update SearchBarWidget ([`d559b90`](https://github.com/mikyll/ROQuiz/commit/d559b903ce71268625f7c672d5c8ad09a949d2dd))
- Update ViewMenu.dart ([`9d44a3f`](https://github.com/mikyll/ROQuiz/commit/9d44a3f6b1d4d69b398d3631dd0dc107a8a8c82d))

### 2023-12-08

- update ([`018970e`](https://github.com/mikyll/ROQuiz/commit/018970e98f8097e26b3808167d3dfc38e9fc26c4))
- update ([`023ca9e`](https://github.com/mikyll/ROQuiz/commit/023ca9e7908dae9dad7515729856ec3150b0397f))

### 2023-12-06

- Fixed Question widget border radius ([`daaa66e`](https://github.com/mikyll/ROQuiz/commit/daaa66e2e27e5ff5f0a8f49cdc1048a145191f49))

### 2023-12-05

- update _showConfirmationDialog ([`c681401`](https://github.com/mikyll/ROQuiz/commit/c681401e17dcc59101937f13dbf0951705dfc8f6))

### 2023-12-04

- update supporto logo ([`a277825`](https://github.com/mikyll/ROQuiz/commit/a277825b56a420369d8b6f81f7ebacc1330ab5ec))

## [1.9] - 2023-12-04

### 2023-12-04

- sostituiti widget deprecati ([`c71a7ef`](https://github.com/mikyll/ROQuiz/commit/c71a7efdea136084052c592b61bf724c00ca20d6))
- update layout ([`a2eea98`](https://github.com/mikyll/ROQuiz/commit/a2eea98d786791d85a36900386880e00b09df409))
- Fix bug aggiornamento parametri quiz e presenza argomenti ([`5bfce4f`](https://github.com/mikyll/ROQuiz/commit/5bfce4f85c21f148518799037725baad506867f0))
- update grafico ([`886c70b`](https://github.com/mikyll/ROQuiz/commit/886c70b1d44e072776c7edd9a79a35283300ac20))
- Update ViewMenu.dart ([`5835659`](https://github.com/mikyll/ROQuiz/commit/5835659c26a8f6a3c5ea4e44b0b84f22bd4ed4ab))

### 2023-12-03

- update stile ([`c764752`](https://github.com/mikyll/ROQuiz/commit/c7647525383c9bbf17e9aa4439e45e501063e266))
- Risolto bug #17 ([`a803d82`](https://github.com/mikyll/ROQuiz/commit/a803d823e388d059cd81befb3a08d14729c5261f))

### 2023-09-10

- Update ViewMenu.dart ([`e242579`](https://github.com/mikyll/ROQuiz/commit/e2425797145145ea42308c933db4de2ada9c36b8))

### 2023-09-08

- update resources ([`4528a6d`](https://github.com/mikyll/ROQuiz/commit/4528a6d61c1e621e70e799a4613e2efd3d95ae82))
- update resources ([`0e9eb33`](https://github.com/mikyll/ROQuiz/commit/0e9eb33e7ee42067dc2b98b4da4b0b32f572dec4))

### 2023-09-04

- Update README.md ([`b979af7`](https://github.com/mikyll/ROQuiz/commit/b979af7ba30acd12c9bf2c788ad2ddf3f611ce22))

### 2023-09-03

- update ([`42d70c8`](https://github.com/mikyll/ROQuiz/commit/42d70c8a493f40699967dc8c72746e11652822bb))
- Update README.md ([`dff566f`](https://github.com/mikyll/ROQuiz/commit/dff566fc35a2417a647c1634bac5225a55d45657))
- update resources ([`23530d9`](https://github.com/mikyll/ROQuiz/commit/23530d950e73405d8aa5c9422852942eb450b377))

### 2023-09-02

- Update ViewQuestions.dart ([`5927cbe`](https://github.com/mikyll/ROQuiz/commit/5927cbe56836e921d57abe34d70e0103dd525635))
- Update README.md ([`4a599c7`](https://github.com/mikyll/ROQuiz/commit/4a599c74de74dbd4e9a700f67c6da35a41c04c52))
- Update README.md ([`db320e7`](https://github.com/mikyll/ROQuiz/commit/db320e77dc0a909d2a7bafa94203c43728db34ba))
- Update update_readme.yml ([`7a82dc5`](https://github.com/mikyll/ROQuiz/commit/7a82dc5f2c3934592fe6367a73e9e012f75acff9))
- Update update_readme.yml ([`8a1a063`](https://github.com/mikyll/ROQuiz/commit/8a1a0636183817db109c8b96fbee1eb0ce112635))
- Update update_readme.yml ([`e9d3401`](https://github.com/mikyll/ROQuiz/commit/e9d3401def8407f02f2351f8367a07b450daef16))
- Update update_readme.yml ([`0d236b2`](https://github.com/mikyll/ROQuiz/commit/0d236b28b875cf0ee2e893889a5a317813bc02a9))
- Update update_readme.yml ([`7800d2b`](https://github.com/mikyll/ROQuiz/commit/7800d2bf30615c354651e615c4ead5d76df6f9e1))
- Update README.md ([`a2c0b45`](https://github.com/mikyll/ROQuiz/commit/a2c0b45c2f19d3dc17dfdee477ab0b60515a49cf))
- Update update_readme.yml ([`ea42e54`](https://github.com/mikyll/ROQuiz/commit/ea42e541520ccd396b169584ec401b5336892460))
- Update README.md ([`e0391d2`](https://github.com/mikyll/ROQuiz/commit/e0391d28e38f4b87b3967210544518b90c0c4500))
- Update update_readme.yml ([`eb82f2f`](https://github.com/mikyll/ROQuiz/commit/eb82f2f434891a848488e1d4757d8f58efcd0672))
- Update update_readme.yml ([`0fbe64e`](https://github.com/mikyll/ROQuiz/commit/0fbe64e5b2d07c9cab3c7f4625027625cc7f90e2))
- Update README.md ([`91404b4`](https://github.com/mikyll/ROQuiz/commit/91404b4c9dd535e62f93c0a36fa9888b23799b76))
- Update update_readme.yml ([`9182e92`](https://github.com/mikyll/ROQuiz/commit/9182e92a45f93fe650524484819a62e8f6a7450f))
- Update update_readme.yml ([`243a96c`](https://github.com/mikyll/ROQuiz/commit/243a96cf6630f7adde27aa157447e25c10bf71d0))
- Update update_readme.yml ([`ac4a8b5`](https://github.com/mikyll/ROQuiz/commit/ac4a8b543c3fd0bba87cc35ac1978d2d60947bb2))
- Update update_readme.yml ([`86d68f5`](https://github.com/mikyll/ROQuiz/commit/86d68f5988d4a50b1ba6f12cf100e7ebcafcdd71))
- Update README.md ([`6c5f880`](https://github.com/mikyll/ROQuiz/commit/6c5f880655e39fdd69a422c2a67ff2155d97fa98))
- Update update_readme.yml ([`6df4dbf`](https://github.com/mikyll/ROQuiz/commit/6df4dbf8659196120f1cd2886493cf520fcbb9f6))
- Update update_readme.yml ([`657c297`](https://github.com/mikyll/ROQuiz/commit/657c297d2ef9c275969098541107fc87eb79c057))
- Update README.md ([`cbd6312`](https://github.com/mikyll/ROQuiz/commit/cbd63120c112a3ca47c2687b5f609205878c180e))
- Update README.md ([`2cbe653`](https://github.com/mikyll/ROQuiz/commit/2cbe6538cde3277ab1541c91f96282ce908f553a))
- Update update_readme.yml ([`2a7c79c`](https://github.com/mikyll/ROQuiz/commit/2a7c79caaf5808df17041fea779567ac986a0de6))
- Update update_readme.yml ([`d07ecfd`](https://github.com/mikyll/ROQuiz/commit/d07ecfd2974b0c2e228762130c948ad8aed2a6b5))
- Update update_readme.yml ([`a96ead8`](https://github.com/mikyll/ROQuiz/commit/a96ead8457581b22461db43f7dce09fe46090a97))
- Update README.md ([`9c904c9`](https://github.com/mikyll/ROQuiz/commit/9c904c9acecb2af36840cbb932b0c9947fcba13f))
- Update README.md ([`665bb10`](https://github.com/mikyll/ROQuiz/commit/665bb105533d3183bf791551349a6ffd5230034f))
- update resources ([`a673955`](https://github.com/mikyll/ROQuiz/commit/a673955498409a45c482482da670448c6658e2ac))
- Update ViewQuiz.dart ([`bea36ab`](https://github.com/mikyll/ROQuiz/commit/bea36ab7b2862e30b55bebce114eeb3fe9d9859d))
- update ([`32a5990`](https://github.com/mikyll/ROQuiz/commit/32a5990b9a7f23d23e61a9393b92798280c7e976))
- update ([`ed11556`](https://github.com/mikyll/ROQuiz/commit/ed1155641fcb18e019f733e7e76a838aac124280))
- Update README.md ([`f369436`](https://github.com/mikyll/ROQuiz/commit/f369436fb1a676c464e305000802cb55b48e0849))
- Update README.md ([`939042d`](https://github.com/mikyll/ROQuiz/commit/939042d70a3f6ed9f7e0c2140c5db9c9041447ab))
- Update pubspec.yaml ([`0ed4cd4`](https://github.com/mikyll/ROQuiz/commit/0ed4cd4912053b58a4b85e50defcaab7f287d52a))

## [1.8] - 2023-09-02

### 2023-09-02

- Update README.md ([`209101d`](https://github.com/mikyll/ROQuiz/commit/209101d42a66a51f1ad9d6c89ab7e4979eb18595))
- update resources ([`6ff2b89`](https://github.com/mikyll/ROQuiz/commit/6ff2b8908a3317e47d3cb2942e49e57a231975d2))
- update resources ([`8278d43`](https://github.com/mikyll/ROQuiz/commit/8278d436479cf85515e56f9e709867a46a726dbb))
- Update topics_widget.dart ([`d78c139`](https://github.com/mikyll/ROQuiz/commit/d78c13983684cd301fa699c89a79d3c09717ebb8))
- update ([`a4a6874`](https://github.com/mikyll/ROQuiz/commit/a4a687417d7c055cf23d1433e8c8aa56c86832f4))
- update ([`fa3f720`](https://github.com/mikyll/ROQuiz/commit/fa3f72048d68a06d7816be9530a169e23719aaf6))
- update ([`ce0230c`](https://github.com/mikyll/ROQuiz/commit/ce0230c83c9e5c57bce73a219eb0e400a8b03ead))
- update ([`b819f19`](https://github.com/mikyll/ROQuiz/commit/b819f19f085eefa95ed533fd79b77d1f90413545))
- updated platform specific code for window size ([`e0127dd`](https://github.com/mikyll/ROQuiz/commit/e0127dd03549ae742edd0db518e1470934fa1971))
- Update README.md ([`57aa904`](https://github.com/mikyll/ROQuiz/commit/57aa9040ca32e7291d5b67617c04511b140e482d))
- Update README.md ([`9502342`](https://github.com/mikyll/ROQuiz/commit/950234243f42116dd10a5920f7b43df52a8dd8e2))
- Update README.md ([`6342867`](https://github.com/mikyll/ROQuiz/commit/6342867dd612ba8a7edc06a1caa56049a9cd01ba))

### 2023-08-28

- update ([`21dc47a`](https://github.com/mikyll/ROQuiz/commit/21dc47a9e46eb1a9f4659039ceacba53facae778))

### 2023-08-18

- Update README.md ([`781d0b1`](https://github.com/mikyll/ROQuiz/commit/781d0b1722dbb85e8349bc0f4a22c81b3c039dc9))

### 2023-08-05

- update README.md ([`9723888`](https://github.com/mikyll/ROQuiz/commit/97238888956d151a4f71c6cb5ac73f2a7879dabf))
- Update README.md ([`bfb3fbf`](https://github.com/mikyll/ROQuiz/commit/bfb3fbfb702f278d7c3cc31de075be5897e18ea5))

## [1.7] - 2023-08-05

### 2023-08-05

- update ([`e42911a`](https://github.com/mikyll/ROQuiz/commit/e42911acf37d0c743f2965bbf0215af8e5433891))
- update ([`08ad7d0`](https://github.com/mikyll/ROQuiz/commit/08ad7d0d3e45f2131c97bdb64d4f9ba603946efa))

### 2023-08-04

- update ([`8569833`](https://github.com/mikyll/ROQuiz/commit/8569833bac9cf3497914974b69638c1dbf3d5da2))
- Update issue templates ([`f9c75c8`](https://github.com/mikyll/ROQuiz/commit/f9c75c88837285d8f976352e9518e3f73be59a3a))
- Update issue templates ([`84b978d`](https://github.com/mikyll/ROQuiz/commit/84b978d1280076cec9d615b3dc90f3fac9ec766e))
- Update ViewSettings.dart ([`b6efc8c`](https://github.com/mikyll/ROQuiz/commit/b6efc8ce697da6e08df54930fb114efa688cf48b))
- Update ViewQuiz.dart ([`5c6472a`](https://github.com/mikyll/ROQuiz/commit/5c6472a269d389279637819e90eaf8908618296a))
- update ([`e53b07d`](https://github.com/mikyll/ROQuiz/commit/e53b07d9aff385f7d39fd3f460001dd7d803ce2b))

### 2023-08-02

- update ([`b8c7b93`](https://github.com/mikyll/ROQuiz/commit/b8c7b93f6a7739147e354ad204080c6dcb3e05d4))

### 2023-08-01

- update ([`9d55fd5`](https://github.com/mikyll/ROQuiz/commit/9d55fd5bf85d7c814cf308d8017f58d6b34b55c9))

### 2023-07-30

- update ([`5c0fed8`](https://github.com/mikyll/ROQuiz/commit/5c0fed8220f989f3ade4f13cfe9b616fb33b11e9))
- Update update_readme.yml ([`d11e780`](https://github.com/mikyll/ROQuiz/commit/d11e7806d5e594a44591d9889b95c8488d1b4133))
- Update file domande ([`d3b6421`](https://github.com/mikyll/ROQuiz/commit/d3b6421b64bec96fb5a2244d060cc9110e1d6bcf))
- Update README.md ([`79dad2d`](https://github.com/mikyll/ROQuiz/commit/79dad2d92496085209345d56c69decca12ede08d))
- Update check_file_domande.yml ([`04d6c53`](https://github.com/mikyll/ROQuiz/commit/04d6c53d9198d05582de965f4eddf9275cf4aaad))

### 2023-07-28

- ViewQuestions & ViewTopics ([`d8af18c`](https://github.com/mikyll/ROQuiz/commit/d8af18c2f67787b9c6b37f15d3260922b4031c16))

### 2023-07-26

- update ViewSettings ([`b927a6a`](https://github.com/mikyll/ROQuiz/commit/b927a6ad3e005096b89b784c989219dc61c4d7a2))

### 2023-07-25

- update credits view ([`f858dfe`](https://github.com/mikyll/ROQuiz/commit/f858dfe9f5ac5a6386330ea6f5b1de48f67044b8))
- android fix package name ([`c7744d5`](https://github.com/mikyll/ROQuiz/commit/c7744d5bca5ad0a701bc39b64e9f125bfe497189))

### 2023-07-24

- update ViewCredits ([`1822c9c`](https://github.com/mikyll/ROQuiz/commit/1822c9cea72ce63b7e490871b5eb64af75ff65fe))
- update broken .gitignore ([`8b68486`](https://github.com/mikyll/ROQuiz/commit/8b68486cf98731353a233590cd3979a05f944ad3))
- risolto bug #10 ([`7ea8e2f`](https://github.com/mikyll/ROQuiz/commit/7ea8e2f212d92f50cae4026aaf0e811a5c5ad75b))

### 2023-07-19

- Aggiunte domande ([`aa3b618`](https://github.com/mikyll/ROQuiz/commit/aa3b61820112c3638861ee69fef01dac5b15684f))

### 2023-07-15

- Add files via upload ([`f580666`](https://github.com/mikyll/ROQuiz/commit/f580666b48860fc1ce0d0766e996777a6abe9ca1))
- Add files via upload ([`95c367b`](https://github.com/mikyll/ROQuiz/commit/95c367bdaed73c1f2e1201f3b0b136881a493d07))

## [1.6] - 2023-07-15

### 2023-07-15

- Update ViewSettings.dart ([`69b6ffc`](https://github.com/mikyll/ROQuiz/commit/69b6ffc81e7812f757e8bf100b8040633e6934cc))
- update ([`91907d3`](https://github.com/mikyll/ROQuiz/commit/91907d3683b1cbd42657e6c52addd15623db4b2a))
- update ([`4247fe5`](https://github.com/mikyll/ROQuiz/commit/4247fe54b0b1493832b3741aff32e71dc39a1f7f))

### 2023-07-14

- confirmation dialogs ([`bd732f9`](https://github.com/mikyll/ROQuiz/commit/bd732f9af59555602278a88a2426d1afa28a9667))
- update mobile app ([`837af44`](https://github.com/mikyll/ROQuiz/commit/837af44247fb6bf682bfd15bffcab042259fc5fd))
- ROQuiz thumbnail ([`4930208`](https://github.com/mikyll/ROQuiz/commit/4930208153c30a60a661993425638fa20fc961c9))
- Update README.md ([`c212e94`](https://github.com/mikyll/ROQuiz/commit/c212e943460c7a01c348330ec2db280a34f3c468))
- Update file domande ([`f8245bd`](https://github.com/mikyll/ROQuiz/commit/f8245bd85cfb4ba48a298a2a9b6908bc9da9ff93))
- Update check_file_domande.yml ([`0ac4f2a`](https://github.com/mikyll/ROQuiz/commit/0ac4f2a9f94e0acb5c001854b845f4675cdaf1ff))
- Update check_file_domande.yml ([`5f595e7`](https://github.com/mikyll/ROQuiz/commit/5f595e7c84b95852833ec36cc5700bdfba50da54))
- Update check_file_domande.yml ([`b10871c`](https://github.com/mikyll/ROQuiz/commit/b10871c61a618337420612d2650bd50d50094ed8))
- Update README.md ([`07f2c76`](https://github.com/mikyll/ROQuiz/commit/07f2c762ff3332b7878c22ae3fb984e53f50c8f5))
- Aggiunte domande ([`8951141`](https://github.com/mikyll/ROQuiz/commit/8951141345f4b28b93b08fd30d2403d3039ff7ad))

### 2023-06-15

- Update README.md ([`b8a5134`](https://github.com/mikyll/ROQuiz/commit/b8a513480eb5d2be9a64161bafa52d8bcfb4fa51))

### 2023-01-28

- Update README.md ([`a3c8252`](https://github.com/mikyll/ROQuiz/commit/a3c825245b81d9c5d96a2a748fb36220f34670b7))

### 2023-01-05

- Update ViewSettings.dart ([`e271f21`](https://github.com/mikyll/ROQuiz/commit/e271f21fc1696620d05e1bb819d3369b781cc149))

### 2023-01-04

- update app mobile ([`736c3f9`](https://github.com/mikyll/ROQuiz/commit/736c3f9ebd3007c1808b3629493ee3db45598136))
- update app desktop ([`d1364cb`](https://github.com/mikyll/ROQuiz/commit/d1364cbf6c9c4be4d4e38f5e0745d013d7de6d09))

### 2023-01-03

- Update README.md ([`04c74d6`](https://github.com/mikyll/ROQuiz/commit/04c74d634ef1aeb58e3de465059da268ce2488a5))
- Update README.md ([`fd0433c`](https://github.com/mikyll/ROQuiz/commit/fd0433c3909a0847e0f26fb9eeb7d84b4d572ccb))
- Update README.md ([`c753a75`](https://github.com/mikyll/ROQuiz/commit/c753a751d222485ebb2dce1ccfda4c177f083af6))

### 2022-12-30

- Update README.md ([`e6416bc`](https://github.com/mikyll/ROQuiz/commit/e6416bc3027cccad9a5bd3c0b9f0cf8cc599c5bf))

### 2022-10-13

- Update README.md ([`edbd3af`](https://github.com/mikyll/ROQuiz/commit/edbd3af81f9184d2c8711bcfecc36de85822e647))

### 2022-09-24

- Update README.md ([`f2fc41a`](https://github.com/mikyll/ROQuiz/commit/f2fc41a5ccfe06d6882e7375c7b5669d9134dfeb))

### 2022-08-04

- Update README.md ([`9e5d00a`](https://github.com/mikyll/ROQuiz/commit/9e5d00a4e954aa07e029ed931b597839c9824b21))

### 2022-08-01

- update ([`b743710`](https://github.com/mikyll/ROQuiz/commit/b743710ea9a1df6425752b5d0363930eca0cad4a))

### 2022-07-31

- update ([`6a4aaff`](https://github.com/mikyll/ROQuiz/commit/6a4aaffb5fd96a854607a0053b6d42b5a43b595f))
- update ([`4aa5293`](https://github.com/mikyll/ROQuiz/commit/4aa5293bb715b00a55e0286c33ecfeb89fc31c09))

### 2022-07-30

- Update README.md ([`0d2e284`](https://github.com/mikyll/ROQuiz/commit/0d2e284d51dc68acb5f53a01cee9e42ecd97ecbf))
- update ([`460ac03`](https://github.com/mikyll/ROQuiz/commit/460ac0314c3e63ca4a4894dc5c30127c2b2c0830))
- Update README.md ([`012c4c0`](https://github.com/mikyll/ROQuiz/commit/012c4c078e81b6c22178ada6a10ad3d7590c284b))
- update Readme ([`beb0f43`](https://github.com/mikyll/ROQuiz/commit/beb0f43cf1a37ba0932959ebddf2007bc48bf6be))
- Update ViewQuiz.dart ([`f945314`](https://github.com/mikyll/ROQuiz/commit/f945314f2910f3b98b765ffe29eb155c3351daae))
- update v1.5 ([`239a16b`](https://github.com/mikyll/ROQuiz/commit/239a16bf6b684655499f0eac14ddb60e0e661eef))
- update ([`a488e7a`](https://github.com/mikyll/ROQuiz/commit/a488e7af8f73818f9e6336c0298fd07156622996))

### 2022-07-29

- update ([`d557f48`](https://github.com/mikyll/ROQuiz/commit/d557f48b43c4203e9e224b63ae527642c31edab9))

### 2022-07-28

- update ([`01447d6`](https://github.com/mikyll/ROQuiz/commit/01447d6154be48d98dc15d338b0b7fe99401a422))

### 2022-07-27

- update v1.5 ([`aaee935`](https://github.com/mikyll/ROQuiz/commit/aaee93540d6f51a9e43d21008428c3d0e50df5ff))
- update ([`1086c34`](https://github.com/mikyll/ROQuiz/commit/1086c348dfc3fe6a09a81fd86d82bc82ebe2d07a))
- update ([`e1166c4`](https://github.com/mikyll/ROQuiz/commit/e1166c47d7d17b95c1301f107104d3fb2799b3be))
- update ([`e298c69`](https://github.com/mikyll/ROQuiz/commit/e298c694cc39a7e66658ef81757415bca55fa045))

### 2022-07-26

- update ([`a74b9a5`](https://github.com/mikyll/ROQuiz/commit/a74b9a59da983e08016d022889ae376d15475474))
- update mobile ([`8d6a5b0`](https://github.com/mikyll/ROQuiz/commit/8d6a5b082c000fd70e127491afad3ddb56dabbeb))
- update app mobile ([`c5de494`](https://github.com/mikyll/ROQuiz/commit/c5de494ac69f6a33a36db1fe286b2d80f3de680b))
- Update README.md ([`27c90a3`](https://github.com/mikyll/ROQuiz/commit/27c90a3f205873275158e341a1a0e9d87a2370af))

### 2022-07-22

- update mobile ([`6d015ff`](https://github.com/mikyll/ROQuiz/commit/6d015ff8c828823e69e0f28c70f20a595b4753c7))
- update ([`c1cd86b`](https://github.com/mikyll/ROQuiz/commit/c1cd86b9df8afedaced1214b0f615c28d4efeba1))

### 2022-07-21

- update app desktop ([`d0ab438`](https://github.com/mikyll/ROQuiz/commit/d0ab438cdbb846daf7d5e7dee52e0beec291d66e))
- bozza lista domande ([`e35ea9c`](https://github.com/mikyll/ROQuiz/commit/e35ea9c055dd626854eeebf9a5303e19f9cf9bce))

### 2022-07-16

- Update README.md ([`82986a7`](https://github.com/mikyll/ROQuiz/commit/82986a75915884d98e5fb6295991ade866dd8f44))

## [1.5] - 2022-07-16

### 2022-07-16

- Update README.md ([`262c25a`](https://github.com/mikyll/ROQuiz/commit/262c25af2f3663e00c44d0223378e1f8244e212e))
- update ([`d09009d`](https://github.com/mikyll/ROQuiz/commit/d09009d7135528f01f6a81d1b2cf6075978ad302))

### 2022-07-15

- update ([`c199726`](https://github.com/mikyll/ROQuiz/commit/c19972604c77d1d80dfb46e20221304f77e19474))

### 2022-07-13

- update ([`253e50c`](https://github.com/mikyll/ROQuiz/commit/253e50c73dfc651cb47308c5a6292758fe8a68bf))
- update ([`83a8cab`](https://github.com/mikyll/ROQuiz/commit/83a8caba102c5843e7515f81a88866ee03147aae))

### 2022-07-02

- Update README.md ([`5ba9621`](https://github.com/mikyll/ROQuiz/commit/5ba962192884df0ed09eeee387d046cbc6e7b828))

### 2022-07-01

- Update README.md ([`a0786a6`](https://github.com/mikyll/ROQuiz/commit/a0786a6e282085e5e4a9bebc1d00efc0317d1424))
- update ([`8f64813`](https://github.com/mikyll/ROQuiz/commit/8f648131b0b6ddb3fcef7b0a2d2125f84c2812fb))
- update ([`6e07aa7`](https://github.com/mikyll/ROQuiz/commit/6e07aa7d127ab32b7192fbfb8acb275ab0feb0ea))

### 2022-06-30

- Update README.md ([`f492ce2`](https://github.com/mikyll/ROQuiz/commit/f492ce287c5ef108361af6058a1057833605a2b4))
- update ([`7717e28`](https://github.com/mikyll/ROQuiz/commit/7717e2837af9722fbb57eb8f40bab618429752c5))
- update README.md ([`3a09399`](https://github.com/mikyll/ROQuiz/commit/3a09399cab469be01ab5e12518caaa3598956592))
- Update README.md ([`ee3dba3`](https://github.com/mikyll/ROQuiz/commit/ee3dba360cfcfd2c6921aae5354006e2161092dd))
- Update update_readme.yml ([`cdf6ba9`](https://github.com/mikyll/ROQuiz/commit/cdf6ba9b5b9b4de7e36f47d7ce3fac1cd9353dc5))
- Update update_readme.yml ([`70356a2`](https://github.com/mikyll/ROQuiz/commit/70356a28b342a18c22aeabf855e5bc346449c234))
- Update update_readme.yml ([`ccd2484`](https://github.com/mikyll/ROQuiz/commit/ccd2484a6f14011d726b4c2a8761fd3fc0dd462a))
- update ([`819b94c`](https://github.com/mikyll/ROQuiz/commit/819b94c941ff0762e40f4d9f1ab009c40eed22eb))
- update ([`c933c8b`](https://github.com/mikyll/ROQuiz/commit/c933c8bdd299bea85bca653431599f28797bc01c))

### 2022-06-29

- contrib-readme-action has updated readme ([`c008609`](https://github.com/mikyll/ROQuiz/commit/c008609c856bc2b6c4f74a80177084bc458c6740))
- update ([`38dfdec`](https://github.com/mikyll/ROQuiz/commit/38dfdec56c67474cb2473a8323be3c595642932a))
- Created Domande RO con spiegazione.pdf ([`44496b7`](https://github.com/mikyll/ROQuiz/commit/44496b7ad4f4491ead6ddfa4407fec54c54f971f))
- Delete Domande RO con spiegazione.pdf ([`f7a1c53`](https://github.com/mikyll/ROQuiz/commit/f7a1c53924ddd33cfca426657998faa716e25222))
- contrib-readme-action has updated readme ([`974e459`](https://github.com/mikyll/ROQuiz/commit/974e459c786d44c06f27610de4764a3600509ebc))
- Update README.md ([`0833aac`](https://github.com/mikyll/ROQuiz/commit/0833aac275563f75109b4655e6a04ad4497ffc29))
- Update README.md ([`36c3ba0`](https://github.com/mikyll/ROQuiz/commit/36c3ba064e1c59ac68765ce41f515f25bdb199b8))
- Update README.md ([`beeb5ee`](https://github.com/mikyll/ROQuiz/commit/beeb5eef8a02e500c1dbe13f95f6c1ad98138a60))
- contrib-readme-action has updated readme ([`accc350`](https://github.com/mikyll/ROQuiz/commit/accc3502d44da8675927bd0cba0361c69e8796c7))
- Update update_readme.yml ([`5fc79cb`](https://github.com/mikyll/ROQuiz/commit/5fc79cb516f3fb4072104a8c41c4618251f84c06))
- contrib-readme-action has updated readme ([`a311ea2`](https://github.com/mikyll/ROQuiz/commit/a311ea28a5a6a0de4c1b83b3063f540f4ebb3ebf))
- Update update_readme.yml ([`9778312`](https://github.com/mikyll/ROQuiz/commit/9778312a15236f23d1258d424ba9442f2efca1ed))
- Update README.md ([`5263115`](https://github.com/mikyll/ROQuiz/commit/526311589809e5b970dcce41386311f37fbc435c))
- Create Domande RO con spiegazione.pdf ([`96416f2`](https://github.com/mikyll/ROQuiz/commit/96416f2d3118de19abe030c0f31df68809a241a9))

### 2022-06-26

- update ([`f968825`](https://github.com/mikyll/ROQuiz/commit/f968825e443a3efa5269926f609ccc80baf3a18f))
- update ([`125d729`](https://github.com/mikyll/ROQuiz/commit/125d729a2df51aaaff740d6401825009daa973f5))

### 2022-06-24

- Update README.md ([`2346e32`](https://github.com/mikyll/ROQuiz/commit/2346e325c2c50d0b9fa84d41ff0e4e3e51347a65))
- Update README.md ([`d7c0e29`](https://github.com/mikyll/ROQuiz/commit/d7c0e29239d527cf303340b589c67a294bdc16b9))
- Cambio licenza: CC_BY_--NC--_SA_4.0 ([`052fd6b`](https://github.com/mikyll/ROQuiz/commit/052fd6b5aa20ccbe64b96988bcda4b43f25d47ca))
- update ([`d079e51`](https://github.com/mikyll/ROQuiz/commit/d079e51dd20fa31bd5540a307c2a3cf9fc232e2c))

### 2022-06-22

- Update Domande.txt ([`9f1e48b`](https://github.com/mikyll/ROQuiz/commit/9f1e48b2189cec1d5369c66aa71fbbdc868f568e))

### 2022-06-20

- update ([`03602ea`](https://github.com/mikyll/ROQuiz/commit/03602ea7c1b65717b3735cc07d9f6cd5e74acf43))
- sistemati tooltip ([`983727f`](https://github.com/mikyll/ROQuiz/commit/983727fbf3466d88560c82041cdc2e3f06daab14))
- Update ControllerMenu.java ([`1918803`](https://github.com/mikyll/ROQuiz/commit/19188038f8e4b39e69e204c7df2034d004eaab7f))
- update ([`29fa464`](https://github.com/mikyll/ROQuiz/commit/29fa4648a99f17293ce8e39c8bb679e2150e5f62))

### 2022-06-19

- update ([`3c8dbc6`](https://github.com/mikyll/ROQuiz/commit/3c8dbc639c249128aefab3705e7bd4f370caa7d8))
- Update README.md ([`d8f6832`](https://github.com/mikyll/ROQuiz/commit/d8f683258df9fc721fa906499f205be4a2366fdc))
- update ([`c948bd9`](https://github.com/mikyll/ROQuiz/commit/c948bd981f19d1de6e0283c7287c17e423a404e4))
- update ([`0746e47`](https://github.com/mikyll/ROQuiz/commit/0746e47f099b2f8ab71487b8f769a23304370708))
- update settings ([`4681e6d`](https://github.com/mikyll/ROQuiz/commit/4681e6d1124fdac957a7c922f6c01104d3df76b8))

### 2022-06-18

- update dark theme ([`2cdb66e`](https://github.com/mikyll/ROQuiz/commit/2cdb66ece96de5ec9c502788a7f733f8df7df8f8))
- Update README.md ([`3c24ae3`](https://github.com/mikyll/ROQuiz/commit/3c24ae3d281e1594f90b18fc3fe76c66d917e352))
- Update README.md ([`eecfff4`](https://github.com/mikyll/ROQuiz/commit/eecfff426f809b7b683f3e3a40fb38d3a5b142f6))
- Update README.md ([`5563562`](https://github.com/mikyll/ROQuiz/commit/5563562aad9c8bd9de3484f5d93cedb530e91396))
- rimosso file inutile ([`a428bbc`](https://github.com/mikyll/ROQuiz/commit/a428bbc24bce82b98b681833213e1c2768c79de1))
- Update README.md ([`580786c`](https://github.com/mikyll/ROQuiz/commit/580786c9e5fe0108dbb22f79b21fbcec699a825f))
- update dark theme setting ([`5c16c94`](https://github.com/mikyll/ROQuiz/commit/5c16c949f5d2c845843891333c1f5cf4be096aed))

### 2022-06-17

- Update README.md ([`f22a22b`](https://github.com/mikyll/ROQuiz/commit/f22a22bd5d1323c866c2c5ea68cf55490ad0106a))

### 2022-06-11

- Update README.md ([`501969f`](https://github.com/mikyll/ROQuiz/commit/501969fb945e1c840ca970668ac09c131c650e72))

### 2022-06-01

- Update README.md ([`b2cba9a`](https://github.com/mikyll/ROQuiz/commit/b2cba9a78d39e84593e6f0df1747d34a0ffd8c10))

### 2022-05-31

- fixed NullPointerException ([`d7a8080`](https://github.com/mikyll/ROQuiz/commit/d7a8080d26ef5f6d62d1e8d2ec958d6fe06ed6b9))

### 2022-05-15

- Update README.md ([`1994cbd`](https://github.com/mikyll/ROQuiz/commit/1994cbd0006bd7241573f30dbad06a1886330c77))

### 2022-02-22

- Update README.md ([`0415984`](https://github.com/mikyll/ROQuiz/commit/0415984b4f0be431e6b15019103846dc6b20114f))
- Update README.md ([`3f651cc`](https://github.com/mikyll/ROQuiz/commit/3f651cc56491a9a4881456ada293f35bc9643a80))
- Update pubspec.yaml ([`fcbe391`](https://github.com/mikyll/ROQuiz/commit/fcbe391f22c060ef49b3d461f570bca77f8f32a1))
- Update ViewQuiz.dart ([`da7830e`](https://github.com/mikyll/ROQuiz/commit/da7830e6bd82441760752a8332f23c143381a9f7))
- update ([`2736698`](https://github.com/mikyll/ROQuiz/commit/27366984929f118a17d3bebf83edcfde2e9d8660))
- update ([`712f158`](https://github.com/mikyll/ROQuiz/commit/712f158a35a266e6c04b5ddd1ad5fb6b7753c75e))
- Update ViewInfo.dart ([`d138cc4`](https://github.com/mikyll/ROQuiz/commit/d138cc42e454c52d278504bec763e40e5c6fd5f8))
- Update ViewMenu.dart ([`87cfc54`](https://github.com/mikyll/ROQuiz/commit/87cfc54ac23f9276bdf86ef3ee7285b894d1d67c))
- update ([`0c3914b`](https://github.com/mikyll/ROQuiz/commit/0c3914bdf88a0d52f3829218fb15ed47f6abbcfc))
- update ([`22d75e8`](https://github.com/mikyll/ROQuiz/commit/22d75e8409ccc11c45bd738a85c1d8e3b3c976e0))
- Update ViewMenu.dart ([`bdda6aa`](https://github.com/mikyll/ROQuiz/commit/bdda6aac31af36e503d4d167babdd94827b6d7d5))
- Update ViewInfo.dart ([`d5ff66c`](https://github.com/mikyll/ROQuiz/commit/d5ff66cc3466024222396c1d3137b33d21162139))
- v1.4 quasi completa ([`dd4793c`](https://github.com/mikyll/ROQuiz/commit/dd4793c4b8c1294f44b9d033040c7586e230f231))

### 2022-02-21

- Update README.md ([`cbebb94`](https://github.com/mikyll/ROQuiz/commit/cbebb9473edca5acb98f727c339066d3c1da3f2b))
- update ([`0d6f872`](https://github.com/mikyll/ROQuiz/commit/0d6f8723186152d94bbfbe3ac16b9d3f57ec3501))
- Update ControllerMenu.java ([`bf6ab00`](https://github.com/mikyll/ROQuiz/commit/bf6ab00ca2131d64a74d026e64d656f93f466ceb))
- update ([`f035ca8`](https://github.com/mikyll/ROQuiz/commit/f035ca82b4f63f201a24d7038cde4a8488cb6d90))
- Update README.md ([`d79aaf9`](https://github.com/mikyll/ROQuiz/commit/d79aaf99b4cc1910e37b0979ddc29220652c6c77))
- update mobile ([`b420401`](https://github.com/mikyll/ROQuiz/commit/b420401e7e4c97a92f996afa26dacbaeb78faaa3))
- update ([`940f810`](https://github.com/mikyll/ROQuiz/commit/940f8108818b5bc34ed4857fabf618a72695e825))

### 2022-02-20

- update ([`58b7132`](https://github.com/mikyll/ROQuiz/commit/58b71320c4f8d990308e3f5f8e099fdc31c08648))
- update desktop ([`cd025d8`](https://github.com/mikyll/ROQuiz/commit/cd025d8ef57e4de8b3a0604aff2b325575943bd5))
- Update and rename readme.yml to update_readme.yml ([`bf38fd8`](https://github.com/mikyll/ROQuiz/commit/bf38fd85119c396ac802a92dbb181a833406bd35))
- Update check_file_domande.yml ([`583a05a`](https://github.com/mikyll/ROQuiz/commit/583a05a8619196b96c4b89793eb9fcea2a026384))
- ANSI -> UTF-8 Domande.txt ([`e03da51`](https://github.com/mikyll/ROQuiz/commit/e03da51517fa2a9e2d6f0df7c365df9b6d02a241))
- Update check_file_domande.yml ([`c7b6c4e`](https://github.com/mikyll/ROQuiz/commit/c7b6c4e3ebc17530aacbc148042e5c5ee7095e9e))
- update ([`a54aeba`](https://github.com/mikyll/ROQuiz/commit/a54aebac7bfedaa9200367e9eb946aea9541eaeb))

### 2022-02-19

- update ([`f180c4e`](https://github.com/mikyll/ROQuiz/commit/f180c4e7e4ffd3ab9f0789e6c3a4bc808a5b0943))
- Update readme.yml ([`6adc5ff`](https://github.com/mikyll/ROQuiz/commit/6adc5ffdfac8d2056326cffd48e82a79d5af5299))

### 2022-02-14

- Update README.md ([`55a3b07`](https://github.com/mikyll/ROQuiz/commit/55a3b07e5622320dfdca49aa628efefcd8efc3b0))

### 2022-02-13

- Update check_file_domande.yml ([`a372244`](https://github.com/mikyll/ROQuiz/commit/a372244f28e245744e2633742ba0839caa9d748d))
- Update README.md ([`07944cc`](https://github.com/mikyll/ROQuiz/commit/07944cc14f5696d0c8635fcfd9d34bd3545afa37))
- Create check_file_domande.yml ([`20147d5`](https://github.com/mikyll/ROQuiz/commit/20147d53d09f88a57ae816107b9e7b97d2c46313))
- Update README.md ([`3363b3f`](https://github.com/mikyll/ROQuiz/commit/3363b3f4bea381a555d8e2f67af88eb903516b52))
- Update README.md ([`13218e0`](https://github.com/mikyll/ROQuiz/commit/13218e08bc2cad44a1b6a86d1637fef417ea9cfd))
- Update README.md ([`91fc82e`](https://github.com/mikyll/ROQuiz/commit/91fc82e5bfab384e2bd76673379e46aca601653a))
- Update README.md ([`7c3ea4e`](https://github.com/mikyll/ROQuiz/commit/7c3ea4e6e960e6d45c8b1231f851b86a627989ab))
- Create readme.yml ([`5dc7286`](https://github.com/mikyll/ROQuiz/commit/5dc7286eac65e5c638f633c7d0d5f252c642e737))

### 2022-02-12

- Update README.md ([`3f6aad9`](https://github.com/mikyll/ROQuiz/commit/3f6aad944a02c920884cde6e3330e909e8d7a52b))
- update ([`5f28f0f`](https://github.com/mikyll/ROQuiz/commit/5f28f0f41322e93c31215b7afa9e183435e9bf65))
- update ([`801cb59`](https://github.com/mikyll/ROQuiz/commit/801cb593b2da970778138bfd0e8e52799d6d64a5))
- Update Domande.txt ([`f7ced97`](https://github.com/mikyll/ROQuiz/commit/f7ced972d4f1c3e7765514c37c4f320935372e80))
- Update Domande.txt ([`04d4137`](https://github.com/mikyll/ROQuiz/commit/04d413740da25e67d6817a907ac109ccd98ce59a))
- Update Domande.txt ([`39b7da6`](https://github.com/mikyll/ROQuiz/commit/39b7da6ccb769f126e04af1e745f8fdae397e213))
- Update Domande.txt ([`ac98731`](https://github.com/mikyll/ROQuiz/commit/ac98731195fa7b4c71e6f728f7f36e93f05616a9))
- Update Domande.txt ([`d1f1d7a`](https://github.com/mikyll/ROQuiz/commit/d1f1d7a03e3975fc5c0c2da4a38043621ed98ada))

### 2022-02-11

- Update README.md ([`653a429`](https://github.com/mikyll/ROQuiz/commit/653a4297f7795266e03173c558435d1d034a5f33))

### 2022-02-10

- Update QuestionRepository.java ([`a17a186`](https://github.com/mikyll/ROQuiz/commit/a17a186bca7e21108bd25049f62c8a43232a1c96))
- Update README.md ([`8bf8f42`](https://github.com/mikyll/ROQuiz/commit/8bf8f4217bac3e05e0d1bf2a85f76ba343f08eb7))

### 2022-02-04

- Update README.md ([`4e5d0e7`](https://github.com/mikyll/ROQuiz/commit/4e5d0e7735d96c1b4453d725acbc5755900dc017))
- Update README.md ([`2d35bdb`](https://github.com/mikyll/ROQuiz/commit/2d35bdbe77b07b7ec3ce1c27eae9416f6a01cfde))

### 2022-01-28

- Update Domande.txt ([`2abede7`](https://github.com/mikyll/ROQuiz/commit/2abede7627a38b9b8aa5dfb7beb4a1aa4c4724af))

### 2022-01-24

- Update README.md ([`636d022`](https://github.com/mikyll/ROQuiz/commit/636d0227b2b70ee5991b4c89849f2bd80e9022bb))
- Update README.md ([`2f0bda8`](https://github.com/mikyll/ROQuiz/commit/2f0bda85ae2c25ee4e8fe7a7cc20f23a9537fb06))
- update ([`b9710c2`](https://github.com/mikyll/ROQuiz/commit/b9710c2567c297c6060723fd7afa989978395ad2))
- update ([`0728d70`](https://github.com/mikyll/ROQuiz/commit/0728d70f20690b36e93b8651b829aa8a07451d99))

### 2022-01-21

- update ([`cf3f02b`](https://github.com/mikyll/ROQuiz/commit/cf3f02b1d6767f5e1165cdb38e06ad4024624af2))
- Update README.md ([`904f664`](https://github.com/mikyll/ROQuiz/commit/904f664c962387f4c5386c361434ea14e81d91d7))
- Update README.md ([`f68d5d2`](https://github.com/mikyll/ROQuiz/commit/f68d5d2f95d4450dd009f888862be3f536a94c04))

### 2022-01-20

- Update README.md ([`276b6e8`](https://github.com/mikyll/ROQuiz/commit/276b6e87280d01bd69b2f647d6753e3e5faffae9))
- Update README.md ([`46d764f`](https://github.com/mikyll/ROQuiz/commit/46d764f5aa5f6f768281a6adaf31081fa6a067ca))
- Update README.md ([`45dbbae`](https://github.com/mikyll/ROQuiz/commit/45dbbaef9a9b0d1f0bf21bdf49cd8fe8e4aeb1a7))
- Update .gitignore ([`b16b060`](https://github.com/mikyll/ROQuiz/commit/b16b0606dd20788e5e64fe750565d4aa51f8704e))
- Update README.md ([`f41b9ac`](https://github.com/mikyll/ROQuiz/commit/f41b9ac0ee7422b57a677d0e66439c4af8f000f9))
- Update README.md ([`a4b8b9e`](https://github.com/mikyll/ROQuiz/commit/a4b8b9e868b69a6ed79a996167c7c211ffd2e044))
- Update README.md ([`5165614`](https://github.com/mikyll/ROQuiz/commit/5165614ebaa37b797f59b0ee90f7bfd68888df43))

## [1.4] - 2022-01-20

### 2022-01-20

- update ([`dd9c9b0`](https://github.com/mikyll/ROQuiz/commit/dd9c9b0276afd943ab3ff820dfa7dbff266a7d70))
- update ([`1f4e118`](https://github.com/mikyll/ROQuiz/commit/1f4e118ab0b41d2a322751857a93e7509221b6d7))
- Update README.md ([`4e4b4cb`](https://github.com/mikyll/ROQuiz/commit/4e4b4cbcba79492b2b81fe1c8877c06f3bfc0710))
- Update README.md ([`5a2ef0a`](https://github.com/mikyll/ROQuiz/commit/5a2ef0aa594085a5e9823ad04119c27c32ab39f0))
- update ([`2f806bc`](https://github.com/mikyll/ROQuiz/commit/2f806bcd5c2b12cc04a5d9b7a858959325472731))
- Update .classpath ([`2d719e5`](https://github.com/mikyll/ROQuiz/commit/2d719e5bad9a019ac4d077e818070f5d9836d05c))
- update ([`216a934`](https://github.com/mikyll/ROQuiz/commit/216a93423b82414b8e0feaa403366b5339edd46a))
- Update QuestionRepository.java ([`503ac12`](https://github.com/mikyll/ROQuiz/commit/503ac12c839af9154d97d0a15f3e8ac546e61c90))
- removed unused imports ([`7f5b915`](https://github.com/mikyll/ROQuiz/commit/7f5b91564989641f08093c182c80276a5f41b0ec))
- Update QuestionRepository.java ([`bd1eb2c`](https://github.com/mikyll/ROQuiz/commit/bd1eb2c62cab643e394b9f8082bb7dc129d40249))
- Update ControllerMenu.java ([`ccb7f8c`](https://github.com/mikyll/ROQuiz/commit/ccb7f8c6003bcf1749678048de917e146168c45c))
- Update SettingsSingleton.java ([`0cc4e7b`](https://github.com/mikyll/ROQuiz/commit/0cc4e7bde5b797a6ed9bf6d9bbaaaad10feea1af))
- Update README.md ([`44ad4e8`](https://github.com/mikyll/ROQuiz/commit/44ad4e8b469c0ea39ac730389bee62f887153710))
- update Settings ([`cff4202`](https://github.com/mikyll/ROQuiz/commit/cff4202babf44a343e8ff479d703d38377e6c8b9))

### 2022-01-19

- update ([`cd40607`](https://github.com/mikyll/ROQuiz/commit/cd40607a02f389cc3f7eb497541333459f78932b))
- Update QuestionRepository.java ([`7394166`](https://github.com/mikyll/ROQuiz/commit/739416606a51529ec34f733e41c94abcbc581fad))
- Update QuestionRepository.java ([`bf4c8d8`](https://github.com/mikyll/ROQuiz/commit/bf4c8d82b0400096a1997ead292ee22f639bcc9a))
- update ([`f28128d`](https://github.com/mikyll/ROQuiz/commit/f28128d5b497679e745cd3505bb5cf9d3b8db1f0))
- update ([`8097177`](https://github.com/mikyll/ROQuiz/commit/809717742a67c45f9ca16378c64a4a8b5125b885))
- Update ViewMenu.fxml ([`d45cb27`](https://github.com/mikyll/ROQuiz/commit/d45cb272e9da9d8fd85c6d7a1ff847096f2a8fb1))
- Update ControllerMenu.java ([`f996f23`](https://github.com/mikyll/ROQuiz/commit/f996f23bd3ea984b509a4efdf127ad74ef84067a))
- update ([`954a4e5`](https://github.com/mikyll/ROQuiz/commit/954a4e511d6ed317d945b426ccdaab152b194509))
- Update README.md ([`619484c`](https://github.com/mikyll/ROQuiz/commit/619484cffb87775884fb978fb9c6d348baef3cf3))
- Update README.md ([`8ec7299`](https://github.com/mikyll/ROQuiz/commit/8ec7299cbe04a860378765f683c3a4f139f337e8))
- Update README.md ([`41384e6`](https://github.com/mikyll/ROQuiz/commit/41384e637f3d8236839c9e0d2596f61033512bb7))
- Update README.md ([`6a5c8d7`](https://github.com/mikyll/ROQuiz/commit/6a5c8d77104b976ee6ff2d6aa30d23e354e80b70))
- Update README.md ([`0ad3d70`](https://github.com/mikyll/ROQuiz/commit/0ad3d7064bcb2a3e152c5a4db7d8e67b23db6c8d))

### 2022-01-15

- Update README.md ([`9a6fede`](https://github.com/mikyll/ROQuiz/commit/9a6fede9f3bc60369006a6bfd45003a40bcbf6ca))
- Update README.md ([`6553a5a`](https://github.com/mikyll/ROQuiz/commit/6553a5abde00ae34f3e5e7342bf7a9c1fee2b760))
- update ([`ae895ab`](https://github.com/mikyll/ROQuiz/commit/ae895ab2aaa1cb8d376d6efb78bf76bfc835d75c))
- Migliroata la forma ([`757afc7`](https://github.com/mikyll/ROQuiz/commit/757afc7204d35c90895df34301f3d183e6afd873))

### 2022-01-14

- Fix gif centrate 😎 ([`baac6c5`](https://github.com/mikyll/ROQuiz/commit/baac6c53252defbccbc4cd28378c6eb52b449414))
- refactor struttura ([`e0a6a5f`](https://github.com/mikyll/ROQuiz/commit/e0a6a5fe46de5b7d7e4317849ce0ce3310e831d1))
- update ([`3a03156`](https://github.com/mikyll/ROQuiz/commit/3a03156f4f55bbe65ac0e27edf1e905db9cbcca2))
- Update README.md ([`a52e2e1`](https://github.com/mikyll/ROQuiz/commit/a52e2e1c38f2c89ff0d699e2ed33703277600c0b))
- update ([`c9e46ac`](https://github.com/mikyll/ROQuiz/commit/c9e46ac9c8258b11cf6c1fb9e4691882d81b01ea))

### 2022-01-08

- Update README.md ([`93f83b4`](https://github.com/mikyll/ROQuiz/commit/93f83b499c61843d204d7e39fd2af2b74620f66f))
- Update README.md ([`6964f11`](https://github.com/mikyll/ROQuiz/commit/6964f1152547ea463068efe40eb161cb7c434443))

### 2022-01-03

- Update README.md ([`2421c72`](https://github.com/mikyll/ROQuiz/commit/2421c72a67a0b7cd62ef2e6cf47be2b3f36f5d6e))
- update ([`1e934c1`](https://github.com/mikyll/ROQuiz/commit/1e934c103eb5c1938d442816d75f34b22be57fa6))
- Update README.md ([`bbe2cec`](https://github.com/mikyll/ROQuiz/commit/bbe2cecb362964fd346ae3db0d7817c124a76ed6))
- Update README.md ([`e94f615`](https://github.com/mikyll/ROQuiz/commit/e94f6155b0cad77d63054dccc28188114fb7aa83))
- update ([`4a5b1bc`](https://github.com/mikyll/ROQuiz/commit/4a5b1bc56d860ad25cb160ef91545133622508eb))
- Update README.md ([`30c9a38`](https://github.com/mikyll/ROQuiz/commit/30c9a388833707909aa435536f4c364eaeb13cd0))
- Update README.md ([`dd75c07`](https://github.com/mikyll/ROQuiz/commit/dd75c078688e5b0ed51a12e55521df351dba3707))

## [1.3] - 2022-01-15

### 2022-01-15

- Migliroata la forma ([`757afc7`](https://github.com/mikyll/ROQuiz/commit/757afc7204d35c90895df34301f3d183e6afd873))

### 2022-01-14

- Fix gif centrate 😎 ([`baac6c5`](https://github.com/mikyll/ROQuiz/commit/baac6c53252defbccbc4cd28378c6eb52b449414))
- refactor struttura ([`e0a6a5f`](https://github.com/mikyll/ROQuiz/commit/e0a6a5fe46de5b7d7e4317849ce0ce3310e831d1))
- update ([`3a03156`](https://github.com/mikyll/ROQuiz/commit/3a03156f4f55bbe65ac0e27edf1e905db9cbcca2))
- Update README.md ([`a52e2e1`](https://github.com/mikyll/ROQuiz/commit/a52e2e1c38f2c89ff0d699e2ed33703277600c0b))
- update ([`c9e46ac`](https://github.com/mikyll/ROQuiz/commit/c9e46ac9c8258b11cf6c1fb9e4691882d81b01ea))

### 2022-01-08

- Update README.md ([`93f83b4`](https://github.com/mikyll/ROQuiz/commit/93f83b499c61843d204d7e39fd2af2b74620f66f))
- Update README.md ([`6964f11`](https://github.com/mikyll/ROQuiz/commit/6964f1152547ea463068efe40eb161cb7c434443))

### 2022-01-03

- Update README.md ([`2421c72`](https://github.com/mikyll/ROQuiz/commit/2421c72a67a0b7cd62ef2e6cf47be2b3f36f5d6e))
- update ([`1e934c1`](https://github.com/mikyll/ROQuiz/commit/1e934c103eb5c1938d442816d75f34b22be57fa6))
- Update README.md ([`bbe2cec`](https://github.com/mikyll/ROQuiz/commit/bbe2cecb362964fd346ae3db0d7817c124a76ed6))
- Update README.md ([`e94f615`](https://github.com/mikyll/ROQuiz/commit/e94f6155b0cad77d63054dccc28188114fb7aa83))
- update ([`4a5b1bc`](https://github.com/mikyll/ROQuiz/commit/4a5b1bc56d860ad25cb160ef91545133622508eb))
- Update README.md ([`30c9a38`](https://github.com/mikyll/ROQuiz/commit/30c9a388833707909aa435536f4c364eaeb13cd0))
- Update README.md ([`dd75c07`](https://github.com/mikyll/ROQuiz/commit/dd75c078688e5b0ed51a12e55521df351dba3707))

### 2022-01-02

- update ([`2816adc`](https://github.com/mikyll/ROQuiz/commit/2816adcb307ad28a27686ac7e1b7893979a9ddfc))
- update ([`b1eade3`](https://github.com/mikyll/ROQuiz/commit/b1eade335826313650c57212f36cc5d7bbd95698))
- update ([`5b478c8`](https://github.com/mikyll/ROQuiz/commit/5b478c8c6bf883cb8c6b3ff278e2570f779171e0))

### 2022-01-01

- update ([`c64b277`](https://github.com/mikyll/ROQuiz/commit/c64b277ddbf10863d5863be195169eac8476de1f))
- update ([`cfd2831`](https://github.com/mikyll/ROQuiz/commit/cfd2831596ac50ba38e3717f4bda3ffb6ed61931))
- update ([`28f76f9`](https://github.com/mikyll/ROQuiz/commit/28f76f928ba651a1710269fda011e243a2b86fd3))
- update ([`44e9b45`](https://github.com/mikyll/ROQuiz/commit/44e9b455827bed216ee22c90c7ec669218d25547))
- update ([`f64cbce`](https://github.com/mikyll/ROQuiz/commit/f64cbce74c4a5c53d7c1f1c934694fb6a78d7c44))

### 2021-12-31

- Update QuestionRepository.dart ([`9539461`](https://github.com/mikyll/ROQuiz/commit/9539461d60029b5609e9e654a5f91865995d18a7))
- update ([`a95617d`](https://github.com/mikyll/ROQuiz/commit/a95617dcb645be53b213ea4b543d350420fb9198))
- Update ViewQuiz.dart ([`84684e6`](https://github.com/mikyll/ROQuiz/commit/84684e6a926b944321f7fc3dfdd9f7d6a1f00dd4))
- Update ViewQuiz.dart ([`442b5ba`](https://github.com/mikyll/ROQuiz/commit/442b5bac7f459dbe2ba81ea7ec7ec877c9e9dabd))
- update ([`7f59a57`](https://github.com/mikyll/ROQuiz/commit/7f59a579f4758c8002399ffe7fb74844123a0f8b))
- update ([`58b6e86`](https://github.com/mikyll/ROQuiz/commit/58b6e86a970fd2c5944f692a396344822dfa57cf))
- update ([`ae9b0df`](https://github.com/mikyll/ROQuiz/commit/ae9b0df11b4511f84192adb8ec541c92a57adacc))
- update ([`06abcf8`](https://github.com/mikyll/ROQuiz/commit/06abcf8a58394e5eab4f825649faed5f197088e6))
- Update Quiz.java ([`a975716`](https://github.com/mikyll/ROQuiz/commit/a975716df6aeaa0e140b29f1677efd503baa1bd2))
- Update ViewMenu.fxml ([`8fa6384`](https://github.com/mikyll/ROQuiz/commit/8fa63848e810a5ac84e2487562081a4e21de53f3))
- update ([`c81b87b`](https://github.com/mikyll/ROQuiz/commit/c81b87b74ba0c2c0a10b2520f3460e83acc093f6))

### 2021-12-30

- update ([`814b754`](https://github.com/mikyll/ROQuiz/commit/814b7549e5ced31686e95bf80314da951dcdad4b))
- update ([`a736da9`](https://github.com/mikyll/ROQuiz/commit/a736da985674973a9c2947c4249ab5c4068451db))
- update ([`201ee39`](https://github.com/mikyll/ROQuiz/commit/201ee397d2ef4d95971e732e17c70732a55b56a4))
- update ([`38356b9`](https://github.com/mikyll/ROQuiz/commit/38356b9f5d038e61c6a0ed08024f21e4a8cdda30))

### 2021-12-29

- Update README.md ([`8a13ebf`](https://github.com/mikyll/ROQuiz/commit/8a13ebf74eb8ee88e33ffd592f9c62ba6266c035))

### 2021-12-12

- Update README.md ([`11c1d94`](https://github.com/mikyll/ROQuiz/commit/11c1d94b0d5615ac4a256db44306451c7153a320))

### 2021-09-15

- Update README.md ([`26d0fd1`](https://github.com/mikyll/ROQuiz/commit/26d0fd103a4473491f12acf8df8ff747b5660b8e))

### 2021-09-12

- Update README.md ([`aaa0ff4`](https://github.com/mikyll/ROQuiz/commit/aaa0ff4c0dfe68bbd4f96e2e1c6d60ba254eeb38))

### 2021-09-10

- Update README.md ([`b1e71cc`](https://github.com/mikyll/ROQuiz/commit/b1e71cc04a8f53ab7e361dec2401a6c0b07b5c4a))

### 2021-09-04

- update info icon ([`6fa0d72`](https://github.com/mikyll/ROQuiz/commit/6fa0d72e26e6f7ebbc1d8fd898e99682392e777f))
- Update README.md ([`911e965`](https://github.com/mikyll/ROQuiz/commit/911e9654b7a4dc6fe151eed38b529591b16cf2b4))
- Update README.md ([`37756c9`](https://github.com/mikyll/ROQuiz/commit/37756c9744c75a1973f239cd7d6d44a7038e463d))
- Update README.md ([`78bcde6`](https://github.com/mikyll/ROQuiz/commit/78bcde60f4a4b1ad34d506bd612debb2f4e2d9c9))
- Update README.md ([`a268a6f`](https://github.com/mikyll/ROQuiz/commit/a268a6f82c090842937bcd0434c2f3a733750aad))

### 2021-09-02

- Update .gitignore ([`f78c5b4`](https://github.com/mikyll/ROQuiz/commit/f78c5b4ce64ef9ac70dbd5602cc7a776c7d5b8c2))
- Delete build.fxbuild ([`032abe3`](https://github.com/mikyll/ROQuiz/commit/032abe3aad5af0d1fec5aebac0777ea89f7454f6))
- update ([`2b05e08`](https://github.com/mikyll/ROQuiz/commit/2b05e080a1be90830fa17e11bbac874b46f77f7d))

### 2021-07-25

- Update README.md ([`d622f1f`](https://github.com/mikyll/ROQuiz/commit/d622f1fbcecdd255507b824078b010c35953b20a))
- Update README.md ([`4b392c0`](https://github.com/mikyll/ROQuiz/commit/4b392c0b3c471a8cd5adda648091855d43fdb97a))

### 2021-07-24

- update ([`f0478e5`](https://github.com/mikyll/ROQuiz/commit/f0478e5f8c278fd6d9961a0c75fbe9c13135efe6))
- dio rotto ([`6b01897`](https://github.com/mikyll/ROQuiz/commit/6b0189756e5cb24c008b5d58cf8bf0b8b29794df))
- Update Project Setup.md ([`007fca9`](https://github.com/mikyll/ROQuiz/commit/007fca9d1ee8819b60a204ee39b3d7a8d9258daa))
- Update Project Setup.md ([`0751084`](https://github.com/mikyll/ROQuiz/commit/0751084621665680cc61720ca29c8e0c5f94715b))
- Delete Project setup.md ([`8b525a5`](https://github.com/mikyll/ROQuiz/commit/8b525a573f113e92052e1fe62842d9d579249be4))
- Update README.md ([`d3d2657`](https://github.com/mikyll/ROQuiz/commit/d3d2657087a2599d91bf1e54b1747bba7b6e4cb7))
- Update Project setup.md ([`3313bc2`](https://github.com/mikyll/ROQuiz/commit/3313bc2fbafc60e7fac87c757d934fb1cce8cd8b))
- Update README.md ([`1c38639`](https://github.com/mikyll/ROQuiz/commit/1c38639599dfabb7fc968d6a15acb64c7d717b90))
- Update and rename Java Install.md to Project Setup.md ([`92cf9e6`](https://github.com/mikyll/ROQuiz/commit/92cf9e6b24b015f252591cd808a839877689d1be))
- Update Project Setup (6).png ([`ccdb1b9`](https://github.com/mikyll/ROQuiz/commit/ccdb1b90c66a5e237ea79d18fd0140af72199e99))
- update ([`a418897`](https://github.com/mikyll/ROQuiz/commit/a4188975034869b66aa0871661e286d28d58aedd))
- update pic ([`4bebd7c`](https://github.com/mikyll/ROQuiz/commit/4bebd7cfda02054a749cee4e0c664844abfcc019))
- update ([`3965bc4`](https://github.com/mikyll/ROQuiz/commit/3965bc43f9a149e46ac626758d0a856dde250dfa))

### 2021-07-22

- Update README.md ([`f7ae49f`](https://github.com/mikyll/ROQuiz/commit/f7ae49fd70cbc49d4e53dab613322b054d639f48))

### 2021-07-21

- Update .gitignore ([`e8661da`](https://github.com/mikyll/ROQuiz/commit/e8661da98e1feea1f0fc6560980b6a9aa4a6fe3f))
- Update README.md ([`30e9679`](https://github.com/mikyll/ROQuiz/commit/30e96793a0bcf8f9997cecd316b8e958e3f03a01))

## [1.2] - 2021-07-21

### 2021-07-21

- update ([`7365cf2`](https://github.com/mikyll/ROQuiz/commit/7365cf2e540f3681601980f1ccf2e02f4a922552))
- Update QuestionRepository.java ([`7a7ea57`](https://github.com/mikyll/ROQuiz/commit/7a7ea5741db1adfd93d1911b387b67d5306465e1))
- Update QuestionRepository.java ([`8a436b6`](https://github.com/mikyll/ROQuiz/commit/8a436b6de4e22f1319847907abd35af01284a771))
- update ([`54d26c1`](https://github.com/mikyll/ROQuiz/commit/54d26c158ff715cbb397255f455fc1fd7db153e0))
- update ([`f31e503`](https://github.com/mikyll/ROQuiz/commit/f31e5034987b2deca1e805c14fe4fbcdc762f834))
- Update Project setup.md ([`cd4c8c1`](https://github.com/mikyll/ROQuiz/commit/cd4c8c1391bebcd8949314dc3596156f0f163361))
- update ([`ef68df1`](https://github.com/mikyll/ROQuiz/commit/ef68df1e71c9e1c9aab99b43d3df30eb9f20aab8))
- update ([`f4dc2dc`](https://github.com/mikyll/ROQuiz/commit/f4dc2dcfc511ee4e3e34cfa2e83f11bfad8c30b9))
- update ([`109f5ac`](https://github.com/mikyll/ROQuiz/commit/109f5ac75372ee25e741589767917908e35c9ae1))
- update ([`73c94b3`](https://github.com/mikyll/ROQuiz/commit/73c94b3342970a5b624c7eccfbea786ea8151394))
- Update QuestionRepository.java ([`d1b62e0`](https://github.com/mikyll/ROQuiz/commit/d1b62e002628a30da3a5633ee468a0c3fddb8bd9))
- update ([`98be0c0`](https://github.com/mikyll/ROQuiz/commit/98be0c0c89d1ede81559a94ad54734226c53e22b))
- update ([`58bb80c`](https://github.com/mikyll/ROQuiz/commit/58bb80c957d7e735b94032eb92cf1ebf77d70b3e))
- update ControllerMenu ([`1db1572`](https://github.com/mikyll/ROQuiz/commit/1db157222501b93965928b74ce5c046432859e5b))
- Update README.md ([`213fa62`](https://github.com/mikyll/ROQuiz/commit/213fa6276fd1f1d51a80a4d376171fbd6614b5c0))
- update Info ([`679a019`](https://github.com/mikyll/ROQuiz/commit/679a0198d67dce778703b3b937a09e5237f781af))

### 2021-07-20

- update Settings ([`d4b5c0f`](https://github.com/mikyll/ROQuiz/commit/d4b5c0f7cea5f9b4edac5c9ec9ed6f98b185b47b))
- update Menu ([`151dd11`](https://github.com/mikyll/ROQuiz/commit/151dd11c2a2b70bbb4e5b201e21d58e17773faaf))
- big update ([`7f5ae14`](https://github.com/mikyll/ROQuiz/commit/7f5ae14e5643320871ca8aca2f425cc682b8d47c))

### 2021-07-16

- QuestionRepository error check during file reading ([`4f86d83`](https://github.com/mikyll/ROQuiz/commit/4f86d837cad9fd1acb5921991f41109c8b683f90))
- Update README.md ([`3a04e3d`](https://github.com/mikyll/ROQuiz/commit/3a04e3d4faf56016b4735de34a8e39172050fb37))
- Update README.md ([`6b97445`](https://github.com/mikyll/ROQuiz/commit/6b97445dae17f164818ba2df48810e6622afdf2c))

### 2021-07-15

- question update ([`b83e6f0`](https://github.com/mikyll/ROQuiz/commit/b83e6f0219acaada80bff8b554ac69f46a5d09df))

### 2021-07-14

- Update README.md ([`bad935d`](https://github.com/mikyll/ROQuiz/commit/bad935d7ecb0ced9077b5609c8affe5a167d0657))

### 2021-07-13

- update question correct answer ([`9ac1bfd`](https://github.com/mikyll/ROQuiz/commit/9ac1bfd8c7c22b5e38425456e00097d8986e43fa))
- Update README.md ([`b2ee0d8`](https://github.com/mikyll/ROQuiz/commit/b2ee0d8982b2a62e043c775460bb4123dd7f2cba))
- Update Java Install.md ([`84a103f`](https://github.com/mikyll/ROQuiz/commit/84a103fa7013b051f650618ef171de29ec92550a))
- Update README.md ([`530b975`](https://github.com/mikyll/ROQuiz/commit/530b975d7f53f1fad5b65dc97ad29c35c4b6b9fb))
- Update README.md ([`6cd9b31`](https://github.com/mikyll/ROQuiz/commit/6cd9b3111cf83e17d75f5042510e66381915e65f))
- Update README.md ([`8e66bf7`](https://github.com/mikyll/ROQuiz/commit/8e66bf705db8ef7edc19576aecc0725c4dc13eb6))
- Update README.md ([`96b587d`](https://github.com/mikyll/ROQuiz/commit/96b587dee2e89dc3b2d4b8e737e7dbaac4a2f18e))
- Update README.md ([`72b08b2`](https://github.com/mikyll/ROQuiz/commit/72b08b26856f41460ca962fcffaddb14a1824b43))
- Update README.md ([`afce444`](https://github.com/mikyll/ROQuiz/commit/afce444533406ad92b303ef0e23c7626decf4424))

### 2021-07-12

- Update Main.java ([`b9c1906`](https://github.com/mikyll/ROQuiz/commit/b9c1906d88f9d3a4648bc6958182e69b1c9f38d9))
- Update README.md ([`047d82b`](https://github.com/mikyll/ROQuiz/commit/047d82b828de63c1e39782fa74f12e45c0a9a5ce))
- Create Project setup.md ([`84f8097`](https://github.com/mikyll/ROQuiz/commit/84f8097a7283ee20fb479b9b355c27bef4e1004d))
- refactor grossino ([`3544a2a`](https://github.com/mikyll/ROQuiz/commit/3544a2ac72d10ef97f8ab70facdb234a4e4d3149))
- Update README.md ([`cdad8bb`](https://github.com/mikyll/ROQuiz/commit/cdad8bbda59e6cb4a72a325a51a6b534692e91a5))
- Update Download Build.png ([`3607ce7`](https://github.com/mikyll/ROQuiz/commit/3607ce76be4ed1474c68d3f52da8cd8af3e73c17))
- corrected typo ([`71e0ba1`](https://github.com/mikyll/ROQuiz/commit/71e0ba19529eddafcf4ddc10de2901302baf3df4))

### 2021-07-11

- Update README.md ([`058a0c4`](https://github.com/mikyll/ROQuiz/commit/058a0c46999497afd4de8b540812918cee8e0768))
- Update README.md ([`51af814`](https://github.com/mikyll/ROQuiz/commit/51af81462a2bf36e31d48941451b7e0e478da160))

### 2021-07-10

- update ([`3ef6a1b`](https://github.com/mikyll/ROQuiz/commit/3ef6a1b06e97e0c40df21a9547fb5b485a51c471))
- Update README.md ([`a5eea1b`](https://github.com/mikyll/ROQuiz/commit/a5eea1b3c55e2271d35c9ada38de2048b8802b35))
- update ([`66a5d72`](https://github.com/mikyll/ROQuiz/commit/66a5d72c3feb34ba66751728266a3f1606f71ae7))
- Update Java Install.md ([`da08024`](https://github.com/mikyll/ROQuiz/commit/da0802401719d00c68cb78d15b4d1f25533c9d34))
- Update Java Install.md ([`3450306`](https://github.com/mikyll/ROQuiz/commit/3450306a3662d7ef4d9da5cdd3c418574013cc58))
- Update Java Install.md ([`3929ae8`](https://github.com/mikyll/ROQuiz/commit/3929ae87670b563d3684830eff45fa39c2653650))
- Update README.md ([`1452d2b`](https://github.com/mikyll/ROQuiz/commit/1452d2b46797448f5f2dae6deb75915a481ef582))
- Update Java Install.md ([`5d4fb11`](https://github.com/mikyll/ROQuiz/commit/5d4fb11af7acac9bd37c8c8d588c7def4add19c7))
- Update README.md ([`8b840ec`](https://github.com/mikyll/ROQuiz/commit/8b840ec2da1a54b2a31acbd1e5fcc92bde31f717))
- Update README.md ([`eca8585`](https://github.com/mikyll/ROQuiz/commit/eca8585518d39c520f9ba516fed4926ecdcc4c5f))
- Update README.md ([`35c745b`](https://github.com/mikyll/ROQuiz/commit/35c745b08dfd7d1c7173fcaaac5a1015dcf03193))
- Create Download Build.png ([`ba69fe7`](https://github.com/mikyll/ROQuiz/commit/ba69fe780ec9da7293e851f51c35590f75658263))

## [1.1] - 2021-07-10

### 2021-07-10

- Create Guida installazione Java 11 e Java SDK 11.url ([`e4e8f40`](https://github.com/mikyll/ROQuiz/commit/e4e8f40a20409131c201b06f7b466b5caa40b88a))
- Update README.md ([`1d70aef`](https://github.com/mikyll/ROQuiz/commit/1d70aefdc86eff659405c45c965cafb4d463535c))
- Create Java Install.md ([`50498b8`](https://github.com/mikyll/ROQuiz/commit/50498b8bcee93eaff5555064ced16f8c0bab6a7f))
- Update InstallJava (3).png ([`c05c5de`](https://github.com/mikyll/ROQuiz/commit/c05c5de8cc2aa0cee6adda3a75882c45560fee21))
- update guida ([`d92550f`](https://github.com/mikyll/ROQuiz/commit/d92550f7e1be6209352c0b15866083f98a319cff))
- Update ViewQuiz.fxml ([`7c9196a`](https://github.com/mikyll/ROQuiz/commit/7c9196a2112907df90dc6d038ca4250205acc15c))
- update ([`c90cb42`](https://github.com/mikyll/ROQuiz/commit/c90cb421c198676bb2963ed0b7203ef47cad551e))
- Update Quiz.txt ([`f265f39`](https://github.com/mikyll/ROQuiz/commit/f265f395edf1fab01108d6a54da7e3d1ce097d10))
- Update README.md ([`7423b8d`](https://github.com/mikyll/ROQuiz/commit/7423b8d940b43135d96375b0dac3b889efcf23bb))
- update ([`8a47a87`](https://github.com/mikyll/ROQuiz/commit/8a47a87d235ee875d5cffc1dd380e2cc70d2cc0d))
- micro update ([`e19352b`](https://github.com/mikyll/ROQuiz/commit/e19352b844774a67eca71db5cd9a4774fc543bd1))

## [1.0] - 2021-07-10

### 2021-07-10

- Update README.md ([`9a85d9b`](https://github.com/mikyll/ROQuiz/commit/9a85d9be080fe9c37c20f43c092aeb6e70f3b498))
- Update README.md ([`baeea91`](https://github.com/mikyll/ROQuiz/commit/baeea9123404fc8097d87047291a76ca5709f36d))
- update ([`41c5066`](https://github.com/mikyll/ROQuiz/commit/41c50661bf7d2e1a2f25f830fb944ae1162ec290))
- Update README.md ([`0c8c814`](https://github.com/mikyll/ROQuiz/commit/0c8c8149b0042feebb0f2186429fca9699b8ec4d))
- update ([`f9e6e87`](https://github.com/mikyll/ROQuiz/commit/f9e6e87b4be9e060ced6af71713757211c01815e))
- Update README.md ([`873ebc9`](https://github.com/mikyll/ROQuiz/commit/873ebc959720a9d8367aebb9919ea6c1489e4ed4))
- Update README.md ([`ad3585d`](https://github.com/mikyll/ROQuiz/commit/ad3585d95822ddf35af72d793e5b7c1628134ea3))
- Update README.md ([`bfb7215`](https://github.com/mikyll/ROQuiz/commit/bfb72152bb4acfb48606d88ab68e65243a4a4873))
- Update README.md ([`5a7371f`](https://github.com/mikyll/ROQuiz/commit/5a7371f0c1ade416d1b77b9caa18be44384c18a6))
- Update README.md ([`d7d17b7`](https://github.com/mikyll/ROQuiz/commit/d7d17b7b12b17ea0476d4dfa6b84c5906865476b))
- changed time from 5min to 18min ([`37051d0`](https://github.com/mikyll/ROQuiz/commit/37051d0d080803ec2ba861e36bab5c9061ba97fb))
- application finished ([`c22343c`](https://github.com/mikyll/ROQuiz/commit/c22343cef0b60bd5fa00db05057da997a9083834))

### 2021-07-09

- update stable version ([`4e30ef1`](https://github.com/mikyll/ROQuiz/commit/4e30ef14d56c9cb924123ea3833284c84b40526e))
- update ([`f0bde63`](https://github.com/mikyll/ROQuiz/commit/f0bde63f0c7b0f6c84e1a0602f0c194acf07bd3e))
- update ([`2be04db`](https://github.com/mikyll/ROQuiz/commit/2be04dbb0bd6c70f68007a817718a7cad949be22))
- big update ([`d883413`](https://github.com/mikyll/ROQuiz/commit/d8834130dc9591d3e60bbb9e0e252085d59aea62))
- Update README.md ([`8de8a0e`](https://github.com/mikyll/ROQuiz/commit/8de8a0e12485dd967627e3b240eadad6f6d72999))
- update ([`4c5064c`](https://github.com/mikyll/ROQuiz/commit/4c5064cc2522b3e7c220d85aec8e205017d05124))
- update ([`bf50f60`](https://github.com/mikyll/ROQuiz/commit/bf50f606308db102bb4e48aeace8c267f854b1fc))
- Update README.md ([`d314f3f`](https://github.com/mikyll/ROQuiz/commit/d314f3f00a4773ddef1c2c9ffd4862c790931a74))
- Initial commit ([`c1d8200`](https://github.com/mikyll/ROQuiz/commit/c1d82008ef094e8a3f837cff1cb335f8c8ed93a3))

[Unreleased]: https://github.com/mikyll/ROQuiz/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/mikyll/ROQuiz/compare/v1.11.5...v2.0.0
[1.11.5]: https://github.com/mikyll/ROQuiz/compare/v1.11.4...v1.11.5
[1.11.4]: https://github.com/mikyll/ROQuiz/compare/v1.10.1...v1.11.4
[1.10.1]: https://github.com/mikyll/ROQuiz/compare/v1.10.0...v1.10.1
[1.10.0]: https://github.com/mikyll/ROQuiz/compare/v1.10...v1.10.0
[1.10]: https://github.com/mikyll/ROQuiz/compare/v1.9.0...v1.10
[1.9.0]: https://github.com/mikyll/ROQuiz/compare/v1.9...v1.9.0
[1.9]: https://github.com/mikyll/ROQuiz/compare/v1.8...v1.9
[1.8]: https://github.com/mikyll/ROQuiz/compare/v1.7...v1.8
[1.7]: https://github.com/mikyll/ROQuiz/compare/v1.6...v1.7
[1.6]: https://github.com/mikyll/ROQuiz/compare/v1.5...v1.6
[1.5]: https://github.com/mikyll/ROQuiz/compare/v1.4...v1.5
[1.4]: https://github.com/mikyll/ROQuiz/compare/v1.3-mobile_beta...v1.4
[1.3-mobile_beta]: https://github.com/mikyll/ROQuiz/compare/v1.3...v1.3-mobile_beta
[1.3]: https://github.com/mikyll/ROQuiz/compare/v1.2...v1.3
[1.2]: https://github.com/mikyll/ROQuiz/compare/v1.1...v1.2
[1.1]: https://github.com/mikyll/ROQuiz/compare/v1.0...v1.1
[1.0]: https://github.com/mikyll/ROQuiz/releases/tag/v1.0
