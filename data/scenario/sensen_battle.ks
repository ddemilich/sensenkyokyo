/*
    戦々嬌々戦闘用マクロ定義
    キャラクタ＋各種バーやアイコン
*/
*start

[iscript]

class BattleSection {
    static EVENTS = Object.freeze({
        // 敵生成
        ENEMY_APPEAR: {
            eventName: 'ENEMY_APPEAR',
            jumpLabel: '*battle_enemy_appear'
        },
        ENEMY_REFRESH: {
            eventName: 'ENEMY_REFRESH',
            jumpLabel: '*battle_enemy_refresh'
        },
        HEROINE_APPEAR: {
            eventName: 'HEROINE_APPEAR',
            jumpLabel: '*battle_heroine_appear'
        },
        HEROINE_MOVE: {
            eventName: 'HEROINE_MOVE',
            jumpLabel: '*battle_heroine_move'
        },
        UPKEEP_PHASE_START: {
            eventName: 'UPKEEP_PHASE_START',
            jumpLabel: '*battle_upkeep_phase_start'
        },
        ENEMY_ACTION_DECISION_PHASE_START: {
            eventName: 'ENEMY_ACTION_DECISION_PHASE_START',
            jumpLabel: '*battle_enemy_action_decision_phase_start'
        },
        HEROINE_ACTION_DECISION_PHASE_START: {
            eventName: 'HEROINE_ACTION_DECISION_PHASE_START',
            jumpLabel: '*battle_heroine_action_decision_phase_start'
        },
        RESOLUTION_PHASE_START: {
            eventName: 'RESOLUTION_PHASE_START',
            jumpLabel: '*battle_resolution_phase_start'
        },
        TURN_END_PHASE_START: {
            eventName: 'TURN_END_PHASE_START',
            jumpLabel: '*battle_turn_end_phase_start'
        },
        // ユーザー入力待ちであることがわかる接頭辞の例
        WAIT_FOR_HEROINE_INPUT: {
            eventName: 'WAIT_FOR_HEROINE_INPUT',
            jumpLabel: '*_wait_heroine_input' // 接頭辞で目立たせる
        },
        CHARA_ACTION_REFRESH: {
            eventName: 'CHARA_ACTION_REFRESH',
            jumpLabel: '*chara_action_refresh'
        },
        ENEMY_DAMAGE_DISPLAY: {
            eventName: 'ENEMY_DAMAGE_DISPLAY',
            jumpLabel: '*battle_enemy_damage_display'
        },
        ENEMY_HEAL_DISPLAY: {
            eventName: 'ENEMY_HEAL_DISPLAY',
            jumpLabel: '*battle_enemy_heal_display'
        },
        ENEMY_GUARD_ACTION: {
            eventName: 'ENEMY_GUARD_ACTION',
            jumpLabel: '*battle_enemy_guard_action'
        },
        ENEMY_ER_APPLY_DISPLAY: {
            eventName: 'ENEMY_ER_APPLY_DISPLAY',
            jumpLabel: '*battle_enemy_er_apply_display'
        },
        ENEMY_ENTER_BUNDLE: {
            eventName: 'ENEMY_ENTER_BUNDLE',
            jumpLabel: '*battle_enemy_enter_bundle'
        },
        ENEMY_DESTROY: {
            eventName: 'ENEMY_DESTROY',
            jumpLabel: '*battle_enemy_destroy'
        },
        HEROINE_LEAVE_BUNDLE: {
            eventName: 'HEROINE_LEAVE_BUNDLE',
            jumpLabel: '*battle_heroine_leave_bundle'
        },
        HEROINE_BUNDLE_DAMAGE: {
            eventName: 'HEROINE_BUNDLE_DAMAGE',
            jumpLabel: '*battle_heroine_bundle_damage'
        },
        HEROINE_BUNDLE_LEVELUP: {
            eventName: 'HEROINE_BUNDLE_LEVELUP',
            jumpLabel: "*battle_heroine_bundle_levelup"
        },
        HEROINE_BUNDLE_ER_CHANGE: {
            eventName: 'HEROINE_BUNDLE_ER_CHANGE',
            jumpLabel: "*battle_heroine_er_change"
        },
        HEROINE_BUNDLE_START_ECSTASY: {
            eventName: 'HEROINE_BUNDLE_START_ECSTASY',
            jumpLabel: '*battle_heroine_bundle_start_ecstasy'
        },
        HEROINE_BUNDLE_ECSTASY: {
            eventName: 'HEROINE_BUNDLE_ECSTASY',
            jumpLabel: '*battle_heroine_bundle_ecstasy'
        },
        HEROINE_BUNDLE_END_ECSTASY: {
            eventName: 'HEROINE_BUNDLE_END_ECSTASY',
            jumpLabel: '*battle_heroine_bundle_end_ecstasy'
        },
        HEROINE_RESIST_BUNDLE: {
            eventName: 'HEROINE_RESIST_BUNDLE',
            jumpLabel: '*battle_heroine_resist_bundle'
        },
        HEROINE_BREAK_BUNDLE: {
            eventName: 'HEROINE_BREAK_BUNDLE',
            jumpLabel: '*battle_heroine_break_bundle'
        },
        HEROINE_DAMAGE_DISPLAY: {
            eventName: 'HEROINE_DAMAGE_DISPLAY',
            jumpLabel: '*battle_heroine_damage_display'
        },
        HEROINE_DAMAGE_LAMBDA_CHARGE: {
            eventName: 'HEROINE_DAMAGE_LAMBDA_CHARGE',
            jumpLabel: '*battle_heroine_damage_lambda_charge'
        },
        HEROINE_DAMAGE_GUARD_COUNTER: {
            eventName: 'HEROINE_DAMAGE_GUARD_COUNTER',
            jumpLabel: '*battle_heroine_damage_guard_counter'
        },
        HEROINE_DAMAGE_MU_CHARGE: {
            eventName: 'HEROINE_DAMAGE_MU_CHARGE',
            jumpLabel: '*battle_heroine_damage_mu_charge'
        },
        HEROINE_HEAL_DISPLAY: {
            eventName: 'HEROINE_HEAL_DISPLAY',
            jumpLabel: '*battle_heroine_heal_display'  
        },
        HEROINE_GUARD_ACTION: {
            eventName: 'HEROINE_GUARD_ACTION',
            jumpLabel: '*battle_heroine_guard_action'
        },
        HEROINE_ERBAR_REFRESH: {
            eventName: 'HEROINE_ERBAR_REFRESH',
            jumpLabel: '*battle_heroine_erbar_refresh'
        },
        HEROINE_ACTION_DECISION: {
            eventName: 'HEROINE_ACTION_DECISION',
            jumpLabel: '*battle_heroine_action_decision'
        },
        HEROINE_RESCUE_BUNDLE: {
            eventName: 'HEROINE_RESCUE_BUNDLE',
            jumpLabel: '*battle_heroine_rescue_bundle'
        },
        HEROINE_ENABLE_BUDDY_BONDING: {
            eventName: 'HEROINE_ENABLE_BUDDY_BONDING',
            jumpLabel: '*battle_heroine_enable_buddy_bonding'
        },
        LAMBDA_LIGHTNING_SUNDAY: {
            eventName: 'LAMBDA_LIGHTNING_SUNDAY',
            jumpLabel: '*battle_lambda_lightning_sunday'
        },
        MU_ADRENALINE_RUSH: {
            eventName: 'MU_ADRENALINE_RUSH',
            jumpLabel: '*battle_mu_adrenaline_rush'
        },
        CHARA_SPBAR_REFRESH: {
            eventName: 'CHARA_SPBAR_REFRESH',
            jumpLabel: '*battle_chara_spbar_refresh'
        },
        BATTLE_WIN: {
            eventName: 'BATTLE_WIN',
            jumpLabel: '*battle_win'
        },
        BATTLE_LOSE: {
            eventName: 'BATTLE_LOSE',
            jumpLabel: '*battle_lose'
        },
        // 戦闘終了イベント
        BATTLE_END: {
            eventName: 'BATTLE_END',
            jumpLabel: '*battle_end_sequence'
        },
        // ...
    });
    static #BASE_LP = 100;
    static #BASE_AP = 50;

    // フィールド関係
    // 敵フィールド
    static #ENEMY_START_X = -640; // 初期状態で画面外にいる
    static #ENEMY_START_Y = 360;
    static #ENEMY_WIDTH = 125;
    static #ENEMY_HEIGHT = 175;
    static #ENEMY_FIELD_X = 0;
    static #ENEMY_FIELD_Y = 0;
    static #ENEMY_FIELD_WIDTH  = 640;
    static #ENEMY_FIELD_HEIGHT = 720;

    static #ENEMY_X_RATES_BY_COUNT = {
        1: [0.5],
        2: [0.5, 0.5], 
        3: [0.75, 0.25, 0.25],
        4: [0.75, 0.5, 0.5, 0.25], 
        5: [0.75, 0.75, 0.5, 0.25, 0.25], 
        6: [0.83, 0.66, 0.66, 0.33, 0.33, 0.17] 
    };
    static #ENEMY_Y_RATES_BY_COUNT = {
        1: [0.5], // 1匹の時は真ん中
        2: [0.25, 0.75], // 2匹の時は25%, 75%
        3: [0.5, 0.25, 0.75], // 3匹の時は50%(中央), 25%(上), 75%(下)
        4: [0.5, 0.25, 0.75, 0.5], // 4匹の時は50%(中央), 25%(上), 75%(下), 50%(中央)
        5: [0.25, 0.75, 0.5, 0.25, 0.75], // 5匹の時は25%(上), 75%(下), 50%(中央), 25%(上), 75%(下)
        6: [0.5, 0.25, 0.75, 0.25, 0.75, 0.5] // 6匹の時は50%(中央), 25%(上), 75%(下), 25%(上), 75%(下), 50%(中央)
    };
    
    // ヒロインフィールド
    static #HEROINE_START_X = 1280 + 500; // 初期状態で画面外にいる
    static #HEROINE_START_Y = 360;
    static #HEROINE_FIELD_X = 640;
    static #HEROINE_FIELD_Y = 0;
    static #HEROINE_FIELD_WIDTH  = 640;
    static #HEROINE_FIELD_HEIGHT = 720;
    static #HEROINE_X_RATES_BY_COUNT = {
        1: [0.6], // ヒロインが1人の場合は中央
        2: [0.30, 0.75], // ヒロインが2人の場合は、左寄り、右寄り
    };
    static #HEROINE_Y_RATES_BY_COUNT = {
        1: [0.5], // ヒロインが1人の場合は中央
        2: [0.7, 0.3], // ヒロインが2人の場合は、同じY座標に並べるか、縦に並べるかなどで調整
    };

    // フェーズ定義
    static #PHASES = Object.freeze({
        UPKEEP_PHASE: 'UPKEEP_PHASE',
        ENEMY_ACTION_DECISION_PHASE: 'ENEMY_ACTION_DECISION_PHASE',
        HEROINE_ACTION_DECISION_PHASE: 'HEROINE_ACTION_DECISION_PHASE',
        RESOLUTION_PHASE: 'RESOLUTION_PHASE',
        TURN_END_PHASE: 'TURN_END_PHASE',
    });

    // インスタンス変数
    enemies = [];
    heroines = [];
    eventQueue = [];
    currentTurn = 0;     // 現在のターン数
    currentPhase = null; // 現在のフェイズ名
    isBattleFinished = false; // 戦闘が終了したかどうかのフラグ
    
    constructor(l, m, enemyIdList, enemyLevel) {
        // プレイヤーキャラクターをメンバ変数に格納
        this.lambda = new CharaDisplayData(l, BattleSection.#HEROINE_START_X, BattleSection.#HEROINE_START_Y);
        this.mu = new CharaDisplayData(m, BattleSection.#HEROINE_START_X, BattleSection.#HEROINE_START_Y);
        
        this.heroines.push(this.lambda);
        this.heroines.push(this.mu);

        this.heroines.forEach((charaDisplayData, index) => {
            // BattleSection毎にリセットされる
            charaDisplayData.charaInstance.ultimateUsed = false;
            this.dispatch('HEROINE_APPEAR', { heroineDisp: charaDisplayData });
        });

        // enemyIdList から敵キャラクターのインスタンスを生成
        for (const enemyId of enemyIdList) {
            const { lp, ap } = this.calculateEnemyStats(enemyLevel);

            try {
                const enemyInstance = EnemyFactory.createEnemy(enemyId, lp, ap, BattleSection.#ENEMY_WIDTH, BattleSection.#ENEMY_HEIGHT);
                const enemyDisplayData = new CharaDisplayData(
                    enemyInstance,
                    BattleSection.#ENEMY_START_X,
                    BattleSection.#ENEMY_START_Y
                );
                this.enemies.push(enemyDisplayData);
                this.dispatch('ENEMY_APPEAR', { enemyDisp: enemyDisplayData});
                console.log(`敵 ${enemyInstance.displayName} (LP: ${lp}, AP: ${ap})`);
            } catch (error) {
                console.error(`敵の生成に失敗した: ${error.message}`);
            }
        }

        // 戦闘初期状態のセットアップ
        this.currentTurn = 1;
        this.currentPhase = BattleSection.#PHASES.UPKEEP_PHASE; // 初期フェーズを設定
        this.isBattleFinished = false;

        // 最初のフェーズ開始イベントをキューに追加 (戦闘開始時に一度だけ)
        this.dispatch('UPKEEP_PHASE_START', { turn: this.currentTurn });
        console.log("BattleSection の初期化が完了した。");
        const enemyDisplayNames = this.enemies.map(enemy => enemy.displayName).join(', ');
        console.log(`登場する敵: [${enemyDisplayNames}]`);
    }

    dispatch(eventName, params = {}) {
        const eventDef = BattleSection.EVENTS[eventName];
        if (!eventDef) {
            console.error(`[BattleSection] 未定義のイベント名がディスパッチされました: ${eventName}`);
            return;
        }
        this.eventQueue.push(new GameEvent(eventDef, params, eventDef.jumpLabel));
        console.log(`JS: イベント '${eventName}' をキューに追加しました。`);
    }

    calculateEnemyStats(level) {
        // AP上昇率 = 1.0 + 1.0 * (level / 200)
        const apMultiplier = 1.0 + 1.0 * (level / 200);
        // LP上昇率 = 1.0 + 1.0 * (level / 200)
        const lpMultiplier = 1.0 + 1.0 * (level / 200);

        const calculatedAp = BattleSection.#BASE_AP * apMultiplier;
        const calculatedLp = BattleSection.#BASE_LP * lpMultiplier;

        return {
            lp: Math.floor(calculatedLp),
            ap: Math.floor(calculatedAp)
        };
    }

    // 汎用処理
    static calculateFloatX(baseX, rate, width) {
        return Math.floor(baseX + rate * width);
    }
    static calculateFloatY(baseY, rate, height) {
        return Math.floor(baseY + rate * height);
    }

    // 敵配置計算機
    enemyLocationX(index) {
        const numEnemies = this.enemies.length;
        const rates = BattleSection.#ENEMY_X_RATES_BY_COUNT[numEnemies];

        if (!rates || index >= rates.length) {
            console.warn(`[enemyLocationX] 不明な敵数またはインデックス: enemies.length=${numEnemies}, index=${index}`);
            return BattleSection.calculateFloatX(BattleSection.#ENEMY_FIELD_X, 0.5, BattleSection.#ENEMY_FIELD_WIDTH); // デフォルト値を返す
        }

        return BattleSection.calculateFloatX(BattleSection.#ENEMY_FIELD_X, rates[index], BattleSection.#ENEMY_FIELD_WIDTH);
    }
    enemyLocationY(index) {
        const numEnemies = this.enemies.length;
        const rates = BattleSection.#ENEMY_Y_RATES_BY_COUNT[numEnemies];

        if (!rates || index >= rates.length) {
            console.warn(`[enemyLocationY] 不明な敵数またはインデックス: enemies.length=${numEnemies}, index=${index}`);
            return BattleSection.calculateFloatY(BattleSection.#ENEMY_FIELD_Y, 0.5, BattleSection.#ENEMY_FIELD_HEIGHT); // デフォルト値を返す
        }
        return BattleSection.calculateFloatY(BattleSection.#ENEMY_FIELD_Y, rates[index], BattleSection.#ENEMY_FIELD_HEIGHT);
    }
    repositionEnemies() {
        this.enemies.forEach((charaDisplayData, index) => {
            const newCenterX = this.enemyLocationX(index);
            const newCenterY = this.enemyLocationY(index);

            charaDisplayData.updatePositionFromCenter(newCenterX, newCenterY);
        });
        this.dispatch('ENEMY_REFRESH', { enemyDisps: this.enemies });
    }
    heroineLocationX(index) {
        const numHeroines = this.heroines.length;
        const rates = BattleSection.#HEROINE_X_RATES_BY_COUNT[numHeroines];

        if (!rates || index >= rates.length) {
            console.warn(`[heroineLocationX] 不明なヒロイン数またはインデックス: heroines.length=${numHeroines}, index=${index}`);
            return BattleSection.calculateFloatX(BattleSection.#HEROINE_FIELD_X, 0.5, BattleSection.#HEROINE_FIELD_WIDTH); // デフォルト値を返す
        }
        return BattleSection.calculateFloatX(BattleSection.#HEROINE_FIELD_X, rates[index], BattleSection.#HEROINE_FIELD_WIDTH);
    }
    heroineLocationY(index) {
        const numHeroines = this.heroines.length;
        const rates = BattleSection.#HEROINE_Y_RATES_BY_COUNT[numHeroines];

        if (!rates || index >= rates.length) {
            console.warn(`[heroineLocationY] 不明なヒロイン数またはインデックス: heroines.length=${numHeroines}, index=${index}`);
            return BattleSection.calculateFloatY(BattleSection.#HEROINE_FIELD_Y, 0.5, BattleSection.#HEROINE_FIELD_HEIGHT); // デフォルト値を返す
        }
        return BattleSection.calculateFloatY(BattleSection.#HEROINE_FIELD_Y, rates[index], BattleSection.#HEROINE_FIELD_HEIGHT);
    }
    repositionHeroines() {
        this.heroines.forEach((charaDisplayData, index) => {
            const newCenterX = this.heroineLocationX(index);
            const newCenterY = this.heroineLocationY(index);
            charaDisplayData.updatePositionFromCenter(newCenterX, newCenterY);

            if (!charaDisplayData.charaInstance.bundled) {
                this.dispatch('HEROINE_MOVE', { heroineDisp: charaDisplayData });
            }
        });
    }

    getPhaseStartEventKey(phaseName) {
        // ここにフェーズ名とイベント名の変換ルールをカプセル化する
        // 今はシンプルに文字列結合で良い
        return `${phaseName}_START`; 
    }

    // --- フェーズ進行ロジック ---
    advancePhase() {
        let nextPhase = null;

        switch (this.currentPhase) {
            case BattleSection.#PHASES.UPKEEP_PHASE:
                nextPhase = BattleSection.#PHASES.ENEMY_ACTION_DECISION_PHASE;
                break;
            case BattleSection.#PHASES.ENEMY_ACTION_DECISION_PHASE:
                nextPhase = BattleSection.#PHASES.HEROINE_ACTION_DECISION_PHASE;
                break;
            case BattleSection.#PHASES.HEROINE_ACTION_DECISION_PHASE:
                nextPhase = BattleSection.#PHASES.RESOLUTION_PHASE;
                for (const heroDisp of this.heroines) {
                    if (!heroDisp.charaInstance.IsActionDecisionCompleted()) {
                        nextPhase = BattleSection.#PHASES.HEROINE_ACTION_DECISION_PHASE;
                    }
                }
                break;
            case BattleSection.#PHASES.RESOLUTION_PHASE:
                if (this.getTotalPendingActionsCount() > 0) {
                    nextPhase = BattleSection.#PHASES.RESOLUTION_PHASE;
                } else {
                    nextPhase = BattleSection.#PHASES.TURN_END_PHASE;
                }
                break;
            case BattleSection.#PHASES.TURN_END_PHASE:
                this.currentTurn++;
                if (this.checkBattleEndCondition()) {
                    this.isBattleFinished = true;
                    this.currentPhase = null; // 戦闘終了
                    // 戦闘終了イベントをキューに追加
                    this.dispatch('BATTLE_END', {}); 
                    return null; // 戦闘終了したのでフェーズは進まない
                } else {
                    nextPhase = BattleSection.#PHASES.UPKEEP_PHASE;
                }
                break;
            default:
                // 未知のフェーズまたは既に戦闘終了している場合
                this.isBattleFinished = true;
                this.currentPhase = null;
                console.error("Unknown or invalid battle phase transition. Forcing battle end.");
                this.dispatch('BATTLE_END', {});
                return null;
        }

        if (nextPhase) {
            this.currentPhase = nextPhase; // まずフェーズを更新
            const eventKey = this.getPhaseStartEventKey(this.currentPhase);
            if (eventKey) {
                this.dispatch(eventKey, { turn: this.currentTurn });
            } else {
                console.error(`Missing event definition for phase: ${this.currentPhase}_START`);
            }
        }
        return nextPhase;
    }

    processUpkeepPhase() {
        console.log(`JS: --- ターン ${this.currentTurn}: アップキープフェイズ処理実行 ---`);
        for (const heroDisp of this.heroines) {
            this.processCharacterEffects(heroDisp);
        }
        
        for (const enemyDisp of this.enemies) {
            this.processCharacterEffects(enemyDisp);
        }
        // 再配置
        this.repositionEnemies();
        this.repositionHeroines();
    }

    processEnemyActionDecisionPhase() {
        console.log(`JS: --- ターン ${this.currentTurn}: エネミーアクション決定フェイズ処理実行 ---`);
        const activeEnemies = this.enemies.filter(enemyDisp => !enemyDisp.charaInstance.isDefeated() && !enemyDisp.charaInstance.bundled);

        activeEnemies.forEach(enemyDisp => {
            enemyDisp.charaInstance.decideActions(enemyDisp, this.enemies, this.heroines); // 敵のアクション決定ロジック
        });

        const extraActionCount = Math.floor(this.currentTurn / 4);

        // 4. 追加アクションの回数分だけループを回し、ランダムな敵にアクションを付与する
        for (let i = 0; i < extraActionCount; i++) {
            if (activeEnemies.length > 0) {
                // 生存している敵の中からランダムに1体選ぶ
                const randomIndex = Math.floor(Math.random() * activeEnemies.length);
                const extraActionTarget = activeEnemies[randomIndex];
                
                console.log(`JS: ターン経過により、[${extraActionTarget.charaInstance.name}] に追加アクションの機会が与えられました！`);
                
                // 追加のアクションを選択させる
                extraActionTarget.charaInstance.decideOneAction(extraActionTarget, this.enemies, this.heroines);
            }
        }

        // Ultimate使えるなら選択する
        activeEnemies.forEach(enemyDisp => {
            if (enemyDisp.charaInstance.canUseUltimate()) {
                enemyDisp.charaInstance.setActionByKey('Ultimate');
            }
        });
        this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
    }

    executeImmediateAction(heroDisp, actionKey) {
        heroDisp.charaInstance.setActionByKey(actionKey);
        const actionInstance = heroDisp.charaInstance.actions.find(action => action.type === actionKey);
        if (actionInstance) {
            heroDisp.charaInstance.removeAction(actionInstance);
            actionInstance.execute(heroDisp, this.enemies, this.heroines, this.dispatch.bind(this));
        } else {
            console.warn(`${heroDisp.charaInstance.name}には${actionKey}が登録されていません！！`);
        }
    }

    processHeroineActionDecisionPhase() {
        console.log(`JS: --- ターン ${this.currentTurn}: ヒロインアクション決定フェイズ処理実行 ---`);
        const freeHeroines = this.heroines.filter(heroDisp => !heroDisp.charaInstance.bundled);
        const bundledHeroines = this.heroines.filter(heroDisp=> heroDisp.charaInstance.bundled);

        // 拘束されていない子を先にさばく。
        // 救出してしまった際にアクションを選べない事態を避けるため。
        for (const heroDisp of freeHeroines) {
            if (heroDisp.charaInstance.IsActionDecisionCompleted()) {
                // コマンド選択済の場合は次のヒロインへ
                continue;
            }
            if (heroDisp.charaInstance.decideRescue) {
                // 救出が打たれていたら実行
                heroDisp.charaInstance.decideRescue = false;
                this.executeImmediateAction(heroDisp, 'Rescue');
                return;
            }
            if (heroDisp.charaInstance.decideUltimate) {
                // アルティメットが打たれていたら実行
                heroDisp.charaInstance.decideUltimate = false;
                this.executeImmediateAction(heroDisp, 'Ultimate');
                return;
            }
            // 自分以外を探す
            const buddy = this.heroines.find(h => h.charaInstance !== heroDisp.charaInstance);
            // イベント発行
            this.dispatch('HEROINE_ACTION_DECISION', {
                source: heroDisp,
                buddy: buddy.charaInstance,
                enemies: this.enemies.filter(e => (!e.charaInstance.isDefeated() && !e.charaInstance.bundled))
            });
            return;
        }

        // 拘束された子が次
        for (const heroDisp of bundledHeroines) {
            if (heroDisp.charaInstance.IsActionDecisionCompleted()) {
                // コマンド選択済の場合は次のヒロインへ
                continue;
            }
            if (heroDisp.charaInstance.decideUltimate) {
                // アルティメットが打たれていたら実行
                heroDisp.charaInstance.decideUltimate = false;
                this.executeImmediateAction(heroDisp, 'Ultimate');
            }
            // 自分以外を探す
            const buddy = this.heroines.find(h => h.charaInstance !== heroDisp.charaInstance);
            // イベント発行
            this.dispatch('HEROINE_ACTION_DECISION', {
                source: heroDisp,
                buddy: buddy,
                enemies: this.enemies
            });
            return;
        }
    }

    processResolutionPhase() {
        console.log(`JS: --- ターン ${this.currentTurn}: 解決フェイズ処理実行 ---`);

        // 1. 全キャラクターのアクションを、実行役とセットでタイプ別に収集
        const allHeroines = this.heroines;
        const allEnemies = this.enemies;

        const heroineFirstStrikes = this.extractActionPairs('FirstStrike', allHeroines);
        const heroineChargeBursts = this.extractActionPairs('ChargeBurst', allHeroines);
        const heroineGuardCounters = this.extractActionPairs('GuardCounter', allHeroines);

        const enemyFirstStrikes = this.extractActionPairs('FirstStrike', allEnemies);
        const enemyChargeBursts = this.extractActionPairs('ChargeBurst', allEnemies);
        const enemyGuardCounters = this.extractActionPairs('GuardCounter', allEnemies);

        const enemyUltimates = this.extractActionPairs('Ultimate', allEnemies);

        const heroineConcentrate = this.extractActionPairs('Concentrate', allHeroines);
        const heroineResist = this.extractActionPairs('Resist', allHeroines);
        const heroineBreak = this.extractActionPairs('Break', allHeroines);

        const heroineSpeak = this.extractActionPairs('Speak', allHeroines);

        // 2. 反撃の事前効果を実行
        if (this.preExecuteActionPairs(heroineGuardCounters)) {
            return;
        }
        if (this.preExecuteActionPairs(enemyGuardCounters)) {
            return;
        }
        // 3. 反撃のアクションを実行
        for (const enemyGuardPair of enemyGuardCounters) {
            // 敵の反撃アクション毎に
            if (enemyGuardPair.source.charaInstance.isDefeated()) {
                console.log(`[${enemyGuardPair.source.charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                enemyGuardPair.source.charaInstance.removeActions();
                continue;
            }
            // キャンセル済のアクションは実行しない
            if (enemyGuardPair.action.canceled) {
                enemyGuardPair.source.charaInstance.removeAction(enemyGuardPair.action);
                continue;
            }

            for (const heroinFirstPair of heroineFirstStrikes) {
                if (heroinFirstPair.source.charaInstance.isDefeated()) {
                    console.log(`[${heroinFirstPair.source.charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                    heroinFirstPair.source.charaInstance.removeActions();
                    continue;
                }
                if (heroinFirstPair.action.canceled) {
                    continue;
                }
                // ヒロインの先制攻撃が見つかったらそれをキャンセルして
                heroinFirstPair.action.canceled = true;
                // ガードイベントを発行
                this.dispatch('ENEMY_GUARD_ACTION', {
                    guardian: enemyGuardPair.source,
                    attacker: heroinFirstPair.source,
                    target: heroinFirstPair.action.selectedTarget
                });

                // 敵の反撃アクションを実行する
                enemyGuardPair.source.charaInstance.removeAction(enemyGuardPair.action);
                // キャンセルされたヒロインをターゲットにする
                enemyGuardPair.action.setSelectedTarget(heroinFirstPair.source);
                enemyGuardPair.action.execute(enemyGuardPair.source, this.enemies, this.heroines, this.dispatch.bind(this));
                this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
                return;
            }
            enemyGuardPair.source.charaInstance.removeAction(enemyGuardPair.action);
        }
        for (const heroineGuardPair of heroineGuardCounters) {
            // ヒロインの反撃アクション毎に
            if (heroineGuardPair.source.charaInstance.isDefeated()) {
                console.log(`[${heroineGuardPair.source.charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                heroineGuardPair.source.charaInstance.removeActions();
                continue;
            }
            // キャンセル済のアクションは実行しない
            if (heroineGuardPair.action.canceled) {
                heroineGuardPair.source.charaInstance.removeAction(heroineGuardPair.action);
                continue;
            }
            for (const enemyFirstPair of enemyFirstStrikes) {
                if (enemyFirstPair.source.charaInstance.isDefeated()) {
                    console.log(`[${enemyFirstPair.source.charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                    enemyFirstPair.source.charaInstance.removeActions();
                    continue;
                }
                if (enemyFirstPair.action.canceled) {
                    continue;
                }
                // 敵の先制攻撃が見つかったらそれをキャンセルして
                enemyFirstPair.action.canceled = true;
                // 対象不適正の場合は、再選択。
                if (!enemyFirstPair.action.selectedTarget) {
                    enemyFirstPair.action.decideTargetCharaDisplayData(enemyFirstPair.source, this.enemies, this.heroines);
                }
                // それでもダメな場合は諦める
                if (!enemyFirstPair.action.selectedTarget) {
                    console.warn(`${enemyFirstPair.source.charaInstance.name} - ${enemyFirstPair.actrion.name} は適切な対象を選べませんでした。`);
                    heroineGuardPair.source.charaInstance.removeAction(heroineGuardPair.action);
                    this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
                    return;
                }
                // ガードイベントを発行
                this.dispatch('HEROINE_GUARD_ACTION', {
                    guardian: heroineGuardPair.source,
                    attacker: enemyFirstPair.source,
                    target: enemyFirstPair.action.selectedTarget
                });

                // ヒロインの反撃アクションを実行する
                heroineGuardPair.source.charaInstance.removeAction(heroineGuardPair.action);
                // キャンセルされた敵をターゲットにする
                heroineGuardPair.action.setSelectedTarget(enemyFirstPair.source);
                heroineGuardPair.action.execute(heroineGuardPair.source, this.enemies, this.heroines, this.dispatch.bind(this));
                this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
                return;
            }
            heroineGuardPair.source.charaInstance.removeAction(heroineGuardPair.action);
        }
        // 4. 先制のアクションを実行
        for (const heroinFirstPair of heroineFirstStrikes) {
            if (heroinFirstPair.source.charaInstance.isDefeated()) {
                console.log(`[${heroinFirstPair.source.charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                heroinFirstPair.source.charaInstance.removeActions();
                continue;
            }
            // キャンセル済のアクションは実行しない
            if (heroinFirstPair.action.canceled) {
                heroinFirstPair.source.charaInstance.removeAction(heroinFirstPair.action);
                continue;
            }
            // 対象のアクションにChargeBurstがある場合は１つ見つけてキャンセルする
            const target = heroinFirstPair.action.selectedTarget;
            if (target) {
                const canceled_action = target.charaInstance.actions.find(action => action.type === 'ChargeBurst' && !action.canceled);
                if (canceled_action) {
                    canceled_action.canceled = true;
                }
            }
            // 実行済みのアクションを元の配列から削除
            heroinFirstPair.source.charaInstance.removeAction(heroinFirstPair.action);
            heroinFirstPair.action.execute(heroinFirstPair.source, this.enemies, this.heroines, this.dispatch.bind(this));
            this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
            return;
        }
        for (const enemyFirstPair of enemyFirstStrikes) {
            if (enemyFirstPair.source.charaInstance.isDefeated()) {
                console.log(`[${enemyFirstPair.source.charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                enemyFirstPair.source.charaInstance.removeActions();
                continue;
            }
            // キャンセル済のアクションは実行しない
            if (enemyFirstPair.action.canceled) {
                enemyFirstPair.source.charaInstance.removeAction(enemyFirstPair.action);
                continue;
            }
            // 対象のアクションにChargeBurstがある場合は１つ見つけてキャンセルする
            const target = enemyFirstPair.action.selectedTarget;
            if (target) {
                const canceled_action = target.charaInstance.actions.find(action => action.type === 'ChargeBurst' && !action.canceled);
                if (canceled_action) {
                    canceled_action.canceled = true;
                }
            }
            // 実行済みのアクションを元の配列から削除
            enemyFirstPair.source.charaInstance.removeAction(enemyFirstPair.action);
            enemyFirstPair.action.execute(enemyFirstPair.source, this.enemies, this.heroines, this.dispatch.bind(this));
            this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
            return;
        }
        // 5. 溜めアクションを実行
        if (this.executeActionPairs(heroineChargeBursts)) {
            return;
        }
        if (this.executeActionPairs(enemyChargeBursts)) {
            return;
        }

        // 6. 最後にUltimte
        if (this.executeActionPairs(enemyUltimates)) {
            return;
        }

        // 7. 拘束系アクション
        if (this.executeActionPairs(heroineConcentrate)) {
            return;
        }
        if (this.executeActionPairs(heroineResist)) {
            return;
        }
        if (this.executeActionPairs(heroineBreak)) {
            return;
        }

        // 8. 会話アクション
        if (this.executeActionPairs(heroineSpeak)) {
            return;
        }
    }

    processCleanUpPhase() {
        console.log(`JS: --- ターン ${this.currentTurn}: クリンナップフェイズ処理実行 ---`);
        this.heroines.forEach(heroineDisp => {
            heroineDisp.charaInstance.clearAllTemporaryStatuses();
            heroineDisp.charaInstance.removeActions(); 
        });
        this.enemies.forEach(enemyDisp => {
            enemyDisp.charaInstance.clearAllTemporaryStatuses();
            enemyDisp.charaInstance.removeActions();
        });
        this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
        // 倒された敵キャラクターの分離
        let defeated = this.enemies.filter(enemyDisp => enemyDisp.charaInstance.isDefeated());
        // 倒された敵キャラクターの削除
        defeated.forEach(enemyDisp => {
            // ナンバリングの解放であって、インスタンスの削除ではない(のでこのあとUIで参照しても大丈夫)
            EnemyFactory.releaseEnemy(enemyDisp.charaInstance);
            this.dispatch('ENEMY_DESTROY', { enemy: enemyDisp.charaInstance });
        });
        this.enemies = this.enemies.filter(enemyDisp => !enemyDisp.charaInstance.isDefeated());
    }

    checkBattleEndCondition() {
        // 敵が誰もいなくなったら勝利
        if (this.enemies.length === 0) {
            console.log("JS: 全ての敵を撃破！戦闘勝利！");
            this.dispatch('BATTLE_WIN', { lambda: this.lambda, mu: this.mu });
            return true;
        }
        // ヒロインが二人とも諦めたら敗北
        if (this.lambda.charaInstance.isLosed && this.mu.charaInstance.isLosed) {
            this.dispatch('BATTLE_LOSE', { lambda: this.lambda, mu: this.mu });
            return true;
        } 
        return false;
    }
    extractActionPairs(actionType, charaList) {
        const extractedPairs = [];
        for (const charaDisp of charaList) {
            charaDisp.charaInstance.actions
                .filter(action => action.type === actionType)
                .forEach(action => {
                    extractedPairs.push({ action: action, source: charaDisp });
                });
        }
        return extractedPairs;
    }
    preExecuteActionPairs(actionPairs) {
        for (const pair of actionPairs) {
            const charaInstance = pair.source.charaInstance;

            if (charaInstance.isDefeated()) {
                console.log(`[${charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                charaInstance.removeActions();
                continue; // ここで次の pair へ進む
            }
            if (pair.action.canceled) {
                // cancelされている場合は何も処理を行わない。
                pair.action.preExecuted = true;
            }
            if (pair.action.preExecuted) {
                continue;
            }
            pair.action.preExecute(pair.source, this.enemies, this.heroines, this.dispatch.bind(this));
            return true;
        }
        return false;
    }
    executeActionPairs(actionPairs) {
        for (const pair of actionPairs) {
            const charaInstance = pair.source.charaInstance;

            if (charaInstance.isDefeated()) {
                console.log(`[${charaInstance.name}] はすでに撃破されているため、アクションは実行されません。`);
                charaInstance.removeActions();
                continue; // ここで次の pair へ進む
            }

            // 実行済みのアクションを元の配列から削除
            charaInstance.removeAction(pair.action);
            if (!pair.action.canceled) {
                pair.action.execute(pair.source, this.enemies, this.heroines, this.dispatch.bind(this));
            }
            this.dispatch('CHARA_ACTION_REFRESH', { enemies: this.enemies, heroines: this.heroines });
            return true;
        }
        return false;
    }

    processCharacterEffects(charaDisp) {
        const charaInstance = charaDisp.charaInstance;
        console.log(`[${charaInstance.name}] のエフェクトを処理します。`);
        
        const remainingEffects = charaInstance.activeEffects.filter(effect => {
            effect.tickDownDuration();
            effect.applyEffect(charaDisp, this.enemies, this.heroines, this.dispatch.bind(this));
            return effect.duration !== 0;
        });

        charaInstance.activeEffects = remainingEffects;
    }

    getTotalPendingActionsCount() {
        let totalActions = 0;

        this.heroines.forEach(heroDisp => {
            totalActions += heroDisp.charaInstance.actions.length;
        });
        this.enemies.forEach(enemyDisp => {
            totalActions += enemyDisp.charaInstance.actions.length;
        });

        return totalActions;
    }
}
window.BattleSection = BattleSection;
[endscript]

; layer0 : キャラクタ
; layer1 : キャラクタ名
; layer2 : LP/SPなど基礎ステータス
; layer3 : LP/SPなど基礎ステータス数値
; layer4 : バフ、デバフアイコン
; layer5 : 固定の画像とか
; layer6 : じゃんけんアイコン
; layer7 : 常在エフェクト
; layer8 : ダメージや回復などのエフェクト
; layer9 : の数字

; 敵の登場
[macro name="enemy_appear"]
    ;キャラ定義
    [enemy_new enemy="&mp.enemy"]
    [enemy_show enemy="&mp.enemy" left="&mp.x" top="&mp.y" time="0"]
    ;名前
    [ptext layer="1" name="&mp.enemy.ptextName" text="&mp.enemy.displayName" x="&mp.x" y="&mp.y" width="&mp.enemy.width" edge="2px 0x000000" size="14" align="center" overwrite="true"]
    ;LPバー
    [image layer="2" name="&mp.enemy.lpbarName()" storage="&mp.enemy.getLpbarImagePath()" left="&mp.enemy.lpbarX(mp.x)" top="&mp.enemy.lpbarY(mp.y)" height="&mp.enemy.lpbarHeight" width="&mp.enemy.lpbarWidth"]
    [image layer="2" name="&mp.enemy.lpbarActiveName()" storage="&mp.enemy.getLpbarActiveImagePath()" left="&mp.enemy.lpbarActiveX(mp.x)" top="&mp.enemy.lpbarY(mp.y)" height="&mp.enemy.lpbarHeight" width="&mp.enemy.lpbarActiveWidth()"]
    [ptext layer="3" name="&mp.enemy.lpbarText()" color="white" text="&mp.enemy.lp" size="12" x="&mp.enemy.lpbarX(mp.x)" y="&mp.enemy.lpbarY(mp.y)" width="&mp.enemy.lpbarWidth" align="center" edge="2px 0x000000" overwrite="true"]
    ;SPバー
    [image layer="2" name="&mp.enemy.spbarName()" storage="&mp.enemy.getSpbarImagePath()" left="&mp.enemy.spbarX(mp.x)" top="&mp.enemy.spbarY(mp.y)" width="&mp.enemy.spbarWidth()" height="&mp.enemy.spbarHeight"]
[endmacro]
; 敵の移動
[macro name="enemy_move"]
    [anim name="&mp.enemy.name" left="&mp.x" top="&mp.y" effect="easeOutBack" time="100"]
    [anim name="&mp.enemy.ptextName" left="&mp.x" top="&mp.y" time="0"]
    [anim name="&mp.enemy.lpbarName()" left="&mp.enemy.lpbarX(mp.x)" top="&mp.enemy.lpbarY(mp.y)" time="0"]
    [anim name="&mp.enemy.lpbarActiveName()" left="&mp.enemy.lpbarActiveX(mp.x)" top="&mp.enemy.lpbarY(mp.y)" time="0"]
    [anim name="&mp.enemy.lpbarText()" left="&mp.enemy.lpbarX(mp.x)" top="&mp.enemy.lpbarY(mp.y)" time="0"]
    [anim name="&mp.enemy.spbarName()" left="&mp.enemy.spbarX(mp.x)" top="&mp.enemy.spbarY(mp.y)" time="0"]
[endmacro]
; 敵の一時的な退場
[macro name="enemy_invisible"]
    [anim name="&mp.enemy.name" opacity="0" time="300"]
    [anim name="&mp.enemy.ptextName" opacity="0" time="300"]
    [anim name="&mp.enemy.lpbarName()" opacity="0" time="300"]
    [anim name="&mp.enemy.lpbarActiveName()" opacity="0" time="300"]
    [anim name="&mp.enemy.lpbarText()" opacity="0" time="300"]
    [anim name="&mp.enemy.spbarName()" opacity="0" time="300"]
    [wa]
[endmacro]
[macro name="enemy_visible"]
    [anim name="&mp.enemy.name" opacity="255" time="300"]
    [anim name="&mp.enemy.ptextName" opacity="255" time="300"]
    [anim name="&mp.enemy.lpbarName()" opacity="255" time="300"]
    [anim name="&mp.enemy.lpbarActiveName()" opacity="255" time="300"]
    [anim name="&mp.enemy.lpbarText()" opacity="255" time="300"]
    [anim name="&mp.enemy.spbarName()" opacity="255" time="300"]
    [wa]
[endmacro]
[macro name="enemy_destroy"]
    ;mp.enemy
    [enemy_delete enemy="&mp.enemy"]
    [free layer="1" name="&mp.enemy.ptextName"]
    ;LPバー
    [free layer="2" name="&mp.enemy.lpbarName()"]
    [free layer="2" name="&mp.enemy.lpbarActiveName()"]
    [free layer="3" name="&mp.enemy.lpbarText()"]
    ;SPバー
    [free layer="2" name="&mp.enemy.spbarName()"]
[endmacro]

; 敵のリフレッシュ
[macro name="enemy_refresh"]
    ;mp.enemies
    [iscript]
        tf.enemy_refresh_loop_index = 0;
    [endscript]
*enemy_refresh_loop_start
    [jump target="*enemy_refresh_loop_end" cond="!(tf.enemy_refresh_loop_index < mp.enemies.length)"]
    [enemy_move enemy="&mp.enemies[tf.enemy_refresh_loop_index].charaInstance" x="&mp.enemies[tf.enemy_refresh_loop_index].x" y="&mp.enemies[tf.enemy_refresh_loop_index].y"]
    [iscript]
        tf.enemy_refresh_loop_index++;
    [endscript]
    [jump target="*enemy_refresh_loop_start"]
*enemy_refresh_loop_end
    [wa]
[endmacro]
; ヒロインの登場
[macro name="heroine_appear"]
    [heroine_show heroine="&mp.heroine" left="&mp.x" top="&mp.y" time="0"]
    ;HPバー
    [image layer="2" name="&mp.heroine.lpbarName()" storage="&mp.heroine.getLpbarImagePath()" left="&mp.heroine.lpbarX(mp.x)" top="&mp.heroine.lpbarY(mp.y)" height="&mp.heroine.lpbarHeight" width="&mp.heroine.lpbarWidth"]
    [image layer="2" name="&mp.heroine.lpbarActiveName()" storage="&mp.heroine.getLpbarActiveImagePath()" left="&mp.heroine.lpbarActiveX(mp.x)" top="&mp.heroine.lpbarY(mp.y)" height="&mp.heroine.lpbarHeight" width="&mp.heroine.lpbarActiveWidth()"]
    [ptext layer="3" name="&mp.heroine.lpbarText()" color="white" text="&mp.heroine.lp" size="12" x="&mp.heroine.lpbarX(mp.x)" y="&mp.heroine.lpbarY(mp.y)" width="&mp.heroine.lpbarWidth" align="center" edge="2px 0x000000" overwrite="true"]
    ;SPバー
    [image layer="2" name="&mp.heroine.spbarName()" storage="&mp.heroine.getSpbarImagePath()" left="&mp.heroine.spbarX(mp.x)" top="&mp.heroine.spbarY(mp.y)" width="&mp.heroine.spbarWidth()" height="&mp.heroine.spbarHeight"]
    ;ERバー
    [image layer="2" name="&mp.heroine.erbarName()" storage="&mp.heroine.getErbarImagePath()" left="&mp.heroine.erbarX(mp.x)" top="&mp.heroine.erbarY(mp.y)" width="&mp.heroine.erbarWidth()" height="&mp.heroine.erbarHeight"]
[endmacro]
; ヒロインの移動
[macro name="heroine_move"]
    [anim name="&mp.heroine.name" left="&mp.x" top="&mp.y" effect="easeOutSine" time="100"]
    [anim name="&mp.heroine.lpbarName()" left="&mp.heroine.lpbarX(mp.x)" top="&mp.heroine.lpbarY(mp.y)" time="0"]
    [anim name="&mp.heroine.lpbarActiveName()" left="&mp.heroine.lpbarActiveX(mp.x)" top="&mp.heroine.lpbarY(mp.y)" time="0"]
    [anim name="&mp.heroine.lpbarText()" left="&mp.heroine.lpbarX(mp.x)" top="&mp.heroine.lpbarY(mp.y)" time="0"]
    [anim name="&mp.heroine.spbarName()" left="&mp.heroine.spbarX(mp.x)" top="&mp.heroine.spbarY(mp.y)" time="0"]
    [anim name="&mp.heroine.erbarName()" left="&mp.heroine.erbarX(mp.x)" top="&mp.heroine.erbarY(mp.y)" time="0"]
    [wa]
[endmacro]

; 拘束オブジェクトの出現
;   拘束LPの表示: ptextをlayer9で出して、数字を置く
; 拘束オブジェクトの更新
;   ヒロインのバー関係の操作
;   拘束LPの更新: overwrite="true"なので文字をptextするだけ
; 拘束オブジェクトの退場
;   拘束LPをfreeして
;   hideする

; アクション表示
[macro name="chara_action_show"]
    ; 更新処理も兼ねて。アイコン並べる。
    ; mp.actions
    [iscript]
        tf.action_icon_loop_index = 0;
    [endscript]
*chara_action_show_loop_start
    [jump target="*chara_action_show_loop_end" cond="!(tf.action_icon_loop_index < mp.actions.length)"]
    [image layer="4" storage="&mp.actions[tf.action_icon_loop_index].getImagePath()" left="&mp.chara.actionIconX(mp.x, tf.action_icon_loop_index)" top="&mp.chara.actionIconY(mp.y, tf.action_icon_loop_index)" width="&mp.chara.actionIconSize()" height="&mp.chara.actionIconSize()"]
    [image layer="4" storage="chara/actions/Canceled.png" left="&mp.chara.actionIconX(mp.x, tf.action_icon_loop_index)" top="&mp.chara.actionIconY(mp.y, tf.action_icon_loop_index)" width="&mp.chara.actionIconSize()" height="&mp.chara.actionIconSize()" zindex="10" cond="mp.actions[tf.action_icon_loop_index].canceled"]
    [iscript]
        tf.action_icon_loop_index++;
    [endscript]
    [jump target="*chara_action_show_loop_start"]
*chara_action_show_loop_end
[endmacro]
; 全キャラクターのアクション再表示
[macro name="chara_action_refresh"]
    ;mp.charaDisps
    [iscript]
        tf.chara_action_refresh_index = 0;
    [endscript]
*chara_action_refresh_loop_start
    [jump target="*chara_action_refresh_loop_end" cond="!(tf.chara_action_refresh_index < mp.charaDisps.length)"]
    [chara_action_show chara="&mp.charaDisps[tf.chara_action_refresh_index].charaInstance" x="&mp.charaDisps[tf.chara_action_refresh_index].x" y="&mp.charaDisps[tf.chara_action_refresh_index].y" actions="&mp.charaDisps[tf.chara_action_refresh_index].charaInstance.actions"]
    [iscript]
        tf.chara_action_refresh_index++;
    [endscript]
    [jump target="*chara_action_refresh_loop_start"]
*chara_action_refresh_loop_end
[endmacro]
;敵選択用画像表示
[macro name="enemy_select"]
    ;mp.enemies
    [iscript]
        tf.enemy_select_loop_index = 0;
    [endscript]
*enemy_select_loop_start
    [jump target="*enemy_select_loop_end" cond="!(tf.enemy_select_loop_index < mp.enemies.length)"]
    [button graphic="button/transparent.png" enterimg="button/transparent_mo.png" target="*enemy_select_done" preexp="&tf.enemy_select_loop_index" exp="mp.action.setSelectedTarget(mp.enemies[preexp])" x="&mp.enemies[tf.enemy_select_loop_index].x" y="&mp.enemies[tf.enemy_select_loop_index].y" width="&mp.enemies[tf.enemy_select_loop_index].charaInstance.width" height="&mp.enemies[tf.enemy_select_loop_index].charaInstance.height"]
    [iscript]
        tf.enemy_select_loop_index++;
    [endscript]
    [jump target="*enemy_select_loop_start"]
*enemy_select_loop_end
    [arena_end_button target="*back_to_menu"][s]
*enemy_select_done
    [cm]
[endmacro]

[macro name="heroine_action_buttons"]
    ;mp.heroine
    ;mp.buddy
    ;mp.x
    ;mp.y
    ;mp.enemies
    [button name="action_first" folder="fgimage" graphic="&mp.heroine.actionClasses.get('FirstStrike').imagePath" x="&mp.heroine.actionSelectX(mp.x, 0)" y="&mp.heroine.actionSelectY(mp.y, 0)" width="&mp.heroine.actionSelectWidth()" target="*heroine_action_decision_decided" exp="tf.selectedAction = mp.heroine.setActionByKey('FirstStrike')" cond="!mp.heroine.bundled"]
    [button name="action_guard" folder="fgimage" graphic="&mp.heroine.actionClasses.get('GuardCounter').imagePath" x="&mp.heroine.actionSelectX(mp.x, 0)" y="&mp.heroine.actionSelectY(mp.y, 1)" width="&mp.heroine.actionSelectWidth()" target="*heroine_action_decision_decided" exp="tf.selectedAction = mp.heroine.setActionByKey('GuardCounter')" cond="!mp.heroine.bundled"]
    [button name="action_charge" folder="fgimage" graphic="&mp.heroine.actionClasses.get('ChargeBurst').imagePath" x="&mp.heroine.actionSelectX(mp.x, 0)" y="&mp.heroine.actionSelectY(mp.y, 2)" width="&mp.heroine.actionSelectWidth()" target="*heroine_action_decision_decided" exp="tf.selectedAction = mp.heroine.setActionByKey('ChargeBurst')" cond="!mp.heroine.bundled"]
    [button name="action_rescue" folder="fgimage" graphic="&mp.heroine.actionClasses.get('Rescue').imagePath" x="&mp.heroine.actionSelectX(mp.x, 0)" y="&mp.heroine.actionSelectY(mp.y, 3)" width="&mp.heroine.actionSelectWidth()" target="*heroine_ultimate" exp="mp.heroine.prepareRescue()" cond="mp.heroine.canUseRescue(mp.buddy)"]
    [button name="action_ultimate" folder="fgimage" graphic="&mp.heroine.actionClasses.get('Ultimate').imagePath" x="&mp.heroine.actionSelectX(mp.x, 1)" y="&mp.heroine.actionSelectY(mp.y, 3)" width="&mp.heroine.actionSelectWidth()" target="*heroine_ultimate" exp="mp.heroine.prepareUltimate()" cond="mp.heroine.canUseUltimate()"]
    [button name="action_resist" folder="fgimage" graphic="&mp.heroine.actionClasses.get('Resist').imagePath" x="&mp.heroine.actionSelectX(mp.x, 0)" y="&mp.heroine.actionSelectY(mp.y, 0)" width="&mp.heroine.actionSelectWidth()" target="*heroine_action_decision_decided" exp="tf.selectedAction = mp.heroine.setActionByKey('Resist')" cond="mp.heroine.bundled"]
    [button name="action_break" folder="fgimage" graphic="&mp.heroine.actionClasses.get('Break').imagePath" x="&mp.heroine.actionSelectX(mp.x, 0)" y="&mp.heroine.actionSelectY(mp.y, 1)" width="&mp.heroine.actionSelectWidth()" target="*heroine_action_decision_decided" exp="tf.selectedAction = mp.heroine.setActionByKey('Break')" cond="mp.heroine.bundled"]
    [button name="action_cocent" folder="fgimage" graphic="&mp.heroine.actionClasses.get('Concentrate').imagePath" x="&mp.heroine.actionSelectX(mp.x, 0)" y="&mp.heroine.actionSelectY(mp.y, 2)" width="&mp.heroine.actionSelectWidth()" target="*heroine_action_decision_decided" exp="tf.selectedAction = mp.heroine.setActionByKey('Concentrate')" cond="mp.heroine.bundled"]
    [arena_end_button target="*back_to_menu"][s]
*heroine_ultimate
    [cm]
    [jump target="*heroine_action_button_end"]
*heroine_action_decision_decided
    [cm]
    ; ターゲット選択
    [if exp="tf.selectedAction.needTarget"]
        [enemy_select enemies="&mp.enemies" action="&tf.selectedAction" cond="mp.enemies.length != 0"]
    [endif]
    [chara_action_show chara="&mp.heroine" x="&mp.x" y="&mp.y" actions="&mp.heroine.actions"]
*heroine_action_button_end
[endmacro]
;ヒロインのアクション選択
[macro name="heroine_action_decision"]
    ;mp.heroine
    ;mp.buddy
    ;mp.enemies
    [if exp="mp.heroine.charaInstance.pose=='knockout' && mp.buddy.pose=='knockout'"]
        [glink text="降参する" x="600" y="200" exp="mp.heroine.charaInstance.isLosed=true;mp.buddy.charaInstance.isLosed=true" target="*heroine_action_decision_middle"]
        [glink text="諦めない" x="600" y="400" target="*heroine_action_decision_middle"]
        [s]
    [endif]
*heroine_action_decision_middle
    [if exp="mp.heroine.canSelectAction()"]
        [anim name="&mp.heroine.charaInstance.name" left="-=30" time="100" effect="easeInCirc" cond="mp.heroine.charaInstance.pose=='base'"][wa]
        [heroine_action_buttons heroine="&mp.heroine.charaInstance" buddy="&mp.buddy" x="&mp.heroine.x" y="&mp.heroine.y" enemies="&mp.enemies"]
        [anim name="&mp.heroine.charaInstance.name" left="+=30" time="100" effect="easeInCirc" cond="mp.heroine.charaInstance.pose=='base'"]
    [else]
        [eval exp="mp.heroine.charaInstance.setActionByKey('Speak')"]
    [endif]
[endmacro]

; 消滅
[macro name="defeat"]
    ;mp.chara
    [filter name="&mp.chara.name" brightness="0"]
    [anim name="&mp.chara.name" opacity="0" time="300"]
    [anim name="&mp.chara.ptextName" opacity="0" time="300"]
    [anim name="&mp.chara.lpbarName()" opacity="0" time="300"]
    [anim name="&mp.chara.lpbarActiveName()" opacity="0" time="300"]
    [anim name="&mp.chara.lpbarText()" opacity="0" time="300"]
    [anim name="&mp.chara.spbarName()" opacity="0" time="300"]
    [wa]
    [enemy_hide enemy="&mp.chara" time="0"]
    [enemy_delete enemy="&mp.chara"]
[endmacro]
; ダメージ
[macro name="damage_to"]
    ;mp.targetname
    ;mp.chara
    ;mp.damagevalue
    ;mp.split
    ;mp.x
    ;mp.y
    ;点滅
    [iscript]
        tf.damage_to_loop_index = 0;
    [endscript]
*damage_to_loop_start
    [jump target="*damage_to_total" cond="!(tf.damage_to_loop_index < mp.split.length)"]
    [if exp="mp.split[tf.damage_to_loop_index] == 0"]
        [ptext layer="9" name="&mp.chara.lpDiffName(tf.damage_to_loop_index)" color="yellow" text="MISS!" x="&mp.chara.lpDiffX(mp.x, false)" y="&mp.chara.lpDiffY(mp.y, false)" width="&mp.chara.width" size="32" align="center" edge="4px 0x000000" overwrite="true"]
        [anim name="&mp.chara.lpDiffName(tf.damage_to_loop_index)" top="-=150" opacity="0" time="500"]
        [wait time="100"]
    [else]
        [ptext layer="9" name="&mp.chara.lpDiffName(tf.damage_to_loop_index)" text="&mp.split[tf.damage_to_loop_index]" x="&mp.chara.lpDiffX(mp.x, false)" y="&mp.chara.lpDiffY(mp.y, false)" width="&mp.chara.width" size="32" align="center" edge="4px 0x000000" overwrite="true"]
        [anim name="&mp.chara.lpDiffName(tf.damage_to_loop_index)" top="-=150" opacity="0" time="500"]
        [filter name="&mp.targetname" opacity="64" invert="100"]
        [wait time="50"]
        [filter name="&mp.targetname" opacity="255" invert="0"]
        [wait time="50"]
    [endif]
    [iscript]
        tf.damage_to_loop_index++;
    [endscript]
    [jump target="*damage_to_loop_start"]
    ;ダメージ表示
*damage_to_total
    [if exp="mp.damagevalue == 0"]
        [ptext layer="9" name="&mp.chara.lpDiffName()" color="yellow" text="MISS!" x="&mp.chara.lpDiffX(mp.x, true)" y="&mp.chara.lpDiffY(mp.y, true)" width="&mp.chara.width" size="50" align="center" edge="4px 0x000000" overwrite="true" ]
    [else]
        [ptext layer="9" name="&mp.chara.lpDiffName()" text="&mp.damagevalue" x="&mp.chara.lpDiffX(mp.x, true)" y="&mp.chara.lpDiffY(mp.y, true)" width="&mp.chara.width" size="50" align="center" edge="4px 0x000000" overwrite="true" ]
    [endif]
    [anim name="&mp.chara.lpDiffName()" top="-=10" time="0"]
    [anim name="&mp.chara.lpDiffName()" top="+=10" effect="easeOutElastic" time="400"][wa]
    [anim name="&mp.chara.lpbarActiveName()" width="&mp.chara.lpbarActiveWidth()" left="&mp.chara.lpbarActiveX(mp.x)" time="300"]
    [ptext layer="3" name="&mp.chara.lpbarText()" color="white" text="&mp.chara.lp" size="12" x="&mp.chara.lpbarX(mp.x)" y="&mp.chara.lpbarY(mp.y)" width="&mp.chara.lpbarWidth" align="center" edge="2px 0x000000" overwrite="true"]
    [anim name="&mp.chara.spbarName()" width="&mp.chara.spbarWidth()" left="&mp.chara.spbarX(mp.x)" time="300"]
    [free layer="9" name="&mp.chara.lpDiffName()" wait="true" time="300"]
    [freeimage layer="9" time="0"]
    [wa]
    [if exp="mp.chara.isDefeated()"]
        [defeat chara="&mp.chara"]
    [endif]
[endmacro]

[macro name="er_change_to"]
    ;mp.targetname
    ;mp.chara
    ;mp.value
    ;mp.split
    ;mp.x
    ;mp.y
    ;点滅
    [iscript]
        tf.er_change_to_loop_index = 0;
    [endscript]
*er_change_to_loop_start
    [jump target="*er_change_to_total" cond="!(tf.er_change_to_loop_index < mp.split.length)"]
    [if exp="mp.split[tf.er_change_to_loop_index] == 0"]
        [ptext layer="9" name="&mp.chara.lpDiffName(tf.er_change_to_loop_index)" color="yellow" text="MISS!" x="&mp.chara.lpDiffX(mp.x, false)" y="&mp.chara.lpDiffY(mp.y)" width="&mp.chara.width" size="32" align="center" edge="4px 0x000000" overwrite="true"]
        [anim name="&mp.chara.lpDiffName(tf.er_change_to_loop_index)" top="-=150" opacity="0" time="500"]
        [wait time="100"]
    [else]
        [ptext layer="9" name="&mp.chara.lpDiffName(tf.er_change_to_loop_index)" color="0xfc03db" text="&mp.split[tf.er_change_to_loop_index]" x="&mp.chara.lpDiffX(mp.x, false)" y="&mp.chara.lpDiffY(mp.y)" width="&mp.chara.width" size="32" align="center" edge="4px 0x000000" overwrite="true"]
        [anim name="&mp.chara.lpDiffName(tf.er_change_to_loop_index)" top="-=150" opacity="0" time="500"]
        [filter name="&mp.targetname" opacity="64" invert="100"]
        [wait time="50"]
        [filter name="&mp.targetname" opacity="255" invert="0"]
        [wait time="50"]
    [endif]
    [iscript]
        tf.er_change_to_loop_index++;
    [endscript]
    [jump target="*er_change_to_loop_start"]
    ;ダメージ表示
*er_change_to_total
    [free layer="9" name="&mp.chara.lpDiffName()" wait="true" time="300" wait="true"]
    [freeimage layer="9" time="0"]
    [wa]
[endmacro]
; 回復
[macro name="heal_to"]
    ;mp.chara
    ;mp.healValue
    ;mp.x
    ;mp.y
    ;回復量表示
    [ptext layer="9" color="0x21e43f" name="&mp.chara.lpDiffName()" text="&mp.healValue" x="&mp.chara.lpDiffX(mp.x, true)" y="&mp.chara.lpDiffY(mp.y, true)" width="&mp.chara.width" size="40" align="center" edge="4px 0x000000"]
    [anim name="&mp.chara.lpDiffName()" top="-=10" time="100"][wa]
    [anim name="&mp.chara.lpDiffName()" top="+=10" effect="easeOutElastic" time="400"][wa]
    [anim name="&mp.chara.lpbarActiveName()" width="&mp.chara.lpbarActiveWidth()" left="&mp.chara.lpbarActiveX(mp.x)" time="300"]
    [ptext layer="3" name="&mp.chara.lpbarText()" color="white" text="&mp.chara.lp" size="12" x="&mp.chara.lpbarX(mp.x)" y="&mp.chara.lpbarY(mp.y)" width="&mp.chara.lpbarWidth" align="center" edge="2px 0x000000" overwrite="true"]
    [anim name="&mp.chara.spbarName()" width="&mp.chara.spbarWidth()" left="&mp.chara.spbarX(mp.x)" time="300"]
    [anim name="&mp.chara.erbarName()" width="&mp.chara.erbarWidth()" left="&mp.chara.erbarX(mp.x)" time="300"]
    [free layer="9" name="&mp.chara.lpDiffName()" wait="true" time="300"]
    [wa]
[endmacro]
[macro name="guard_effect"]
    ;mp.chara
    ;mp.x
    ;mp.y
    ;ガード表示
    [ptext layer="9" color="blue" name="&mp.chara.lpDiffName()" text="GUARD" x="&mp.chara.lpDiffX(mp.x, true)" y="&mp.chara.lpDiffY(mp.y, true)" width="&mp.chara.width" size="40" align="center" edge="4px 0x000000"]
    [anim name="&mp.chara.lpDiffName()" top="-=10" time="100"][wa]
    [anim name="&mp.chara.lpDiffName()" top="+=10" effect="easeOutElastic" time="400"][wa]
    [free layer="9" name="&mp.chara.lpDiffName()" wait="true" time="300"]
[endmacro]
[macro name="rescue_effect"]
    ;mp.chara
    ;mp.x
    ;mp.y
    ;レスキュー表示
    [ptext layer="9" color="orange" name="&mp.chara.lpDiffName()" text="RESCUE" x="&mp.chara.lpDiffX(mp.x, true)" y="&mp.chara.lpDiffY(mp.y, true)" width="&mp.chara.width" size="40" align="center" edge="4px 0x000000"]
    [anim name="&mp.chara.lpDiffName()" top="-=10" time="100"][wa]
    [anim name="&mp.chara.lpDiffName()" top="+=10" effect="easeOutElastic" time="400"][wa]
    [free layer="9" name="&mp.chara.lpDiffName()" wait="true" time="300"]
[endmacro]
[macro name="er_apply"]
    ;mp.chara
    ;mp.erValue
    ;mp.current
    ;mp.x
    ;mp.y
    [ptext layer="9" color="0xfc03db" name="&mp.chara.lpDiffName()" text="&mp.erValue" x="&mp.chara.lpDiffX(mp.x, true)" y="&mp.chara.lpDiffY(mp.y, true)" width="&mp.chara.width" size="40" align="center" edge="4px 0x000000"]
    [anim name="&mp.chara.lpDiffName()" top="-=10" time="100"][wa]
    [anim name="&mp.chara.lpDiffName()" top="+=10" effect="easeOutElastic" time="400"][wa]
    [anim name="&mp.chara.erbarName()" width="&mp.chara.erbarWidth(mp.current)" left="&mp.chara.erbarX(mp.x, mp.current)" time="300"]
    [free layer="9" name="&mp.chara.lpDiffName()" wait="true" time="300"]
    [wa]
[endmacro]
[macro name="spbar_refresh"]
    ;mp.chara
    ;mp.x
    ;mp.y
    [anim name="&mp.chara.spbarName()" width="&mp.chara.spbarWidth()" left="&mp.chara.spbarX(mp.x)" time="10"][wa]
[endmacro]
[macro name="turn_text"]
    ;mp.msg;
    [ptext layer="1" name="turnText" size="40" x="320" y="5" width="640" text="&mp.msg" time="500" overwrite="true" align="center"]
[endmacro]

[macro name="bundle_display"]
    ; mp.bundle
    ; mp.x
    ; mp.y
    [bundle_show bundle="&mp.bundle" left="&mp.bundle.x" top="&mp.bundle.y" time="100"]
    [ptext layer="3" color="pink" text="&mp.bundle.lpValue()" name="&mp.bundle.lpName()" x="&mp.bundle.lpX(mp.x)" y="&mp.bundle.lpY(mp.y)" size="&mp.bundle.lpSize()" edge="4px 0x000000" overwrite="true"]
[endmacro]
[macro name="bundle_refresh"]
    ; mp.bundle
    ; mp.x
    ; mp.y
    [bundle_mod bundle="&mp.bundle"]
    [ptext layer="3" color="pink" text="&mp.bundle.lpValue()" name="&mp.bundle.lpName()" x="&mp.bundle.lpX(mp.x)" y="&mp.bundle.lpY(mp.y)" size="&mp.bundle.lpSize()" edge="4px 0x000000" overwrite="true"]
[endmacro]
[macro name="bundle_cancel"]
    ; mp.bundle
    [free layer="3" name="&mp.bundle.lpName()"]
    [bundle_hide bundle="&mp.bundle"]
[endmacro]
[macro name="bundle_break_show"]
    ; mp.bundle
    ; mp.x
    ; mp.y
    ; mp.result
    [bundle_updown bundle="&mp.bundle"]
    [ptext layer="9" color="0x21e43f" name="&mp.bundle.resultName()" text="BREAK!" x="&mp.bundle.resultX()" y="&mp.bundle.resultY()" width="&mp.bundle.width" size="40" align="center" edge="4px 0x000000" cond="mp.result"]
    [ptext layer="9" color="yellow" name="&mp.bundle.resultName()" text="FAIL!" x="&mp.bundle.resultX()" y="&mp.bundle.resultY()" width="&mp.bundle.width" size="40" align="center" edge="4px 0x000000" cond="!mp.result"]
    [anim name="&mp.bundle.resultName()" top="-=10" time="100"][wa]
    [anim name="&mp.bundle.resultName()" top="+=10" effect="easeOutElastic" time="400"][wa]
    [free layer="9" name="&mp.bundle.resultName()" wait="true" time="300"]
[endmacro]
[macro name="heroine_ecstasy"]
    ; mp.bundle
    ; mp.heroine
    ; mp.amount
    ; mp.current
    [iscript]
        mp.bundle.step=2;
    [endscript]
    [bundle_mod bundle="&mp.bundle" time="100"]
    [er_apply chara="&mp.heroine.charaInstance" erValue="&mp.amount" current="&mp.current" x="&mp.heroine.x" y="&mp.heroine.y"]
    [iscript]
        mp.bundle.step=3;
    [endscript]
    [bundle_mod bundle="&mp.bundle" time="300"]
[endmacro]
[macro name="focus_on_chara"]
    ;mp.x
    ;mp.y
    [camera zoom="2" x="&mp.x" y="&mp.y" ease_type="ease-out" time="500"]
    [camera zoom="2" from_zoom="3" from_x="&mp.x" x="&mp.x" from_y="&mp.y" y="&mp.y" ease_type="ease-out" time="250"]
    [reset_camera ease_type="ease-in" time="150"]
[endmacro]

[macro name="process_battle_events"]
    ; mp.battle : バトルセクションオブジェクト
*process_battle_events_start
    ;アニメーション終了をイベントごとに分ける。
    ;並列させたい場合は１イベントに収めること。
    [wa]
    [jump target="*process_battle_events_end" cond="!(tf.currentEvent = mp.battle.eventQueue.shift())"]
    [jump target="&tf.currentEvent.jumpLabel"]

*battle_enemy_appear
    [enemy_appear enemy="&tf.currentEvent.params.enemyDisp.charaInstance" x="&tf.currentEvent.params.enemyDisp.x" y="&tf.currentEvent.params.enemyDisp.y"]
    [jump target="*process_battle_events_start"]
*battle_enemy_refresh
    [enemy_refresh enemies="&tf.currentEvent.params.enemyDisps"]
    [jump target="*process_battle_events_start"]
*battle_heroine_appear
    [heroine_appear heroine="&tf.currentEvent.params.heroineDisp.charaInstance" x="&tf.currentEvent.params.heroineDisp.x" y="&tf.currentEvent.params.heroineDisp.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_move
    [heroine_move heroine="&tf.currentEvent.params.heroineDisp.charaInstance" x="&tf.currentEvent.params.heroineDisp.x" y="&tf.currentEvent.params.heroineDisp.y"]
    [jump target="*process_battle_events_start"]

*battle_upkeep_phase_start
    [turn_text msg="アップキープフェイズ"]
    [eval exp="mp.battle.processUpkeepPhase()"]
    [eval exp="mp.battle.advancePhase()"]
    [jump target="*process_battle_events_start"]
*battle_enemy_action_decision_phase_start
    [freeimage layer="4"]
    [turn_text msg="敵アクション決定フェイズ"]
    [eval exp="mp.battle.processEnemyActionDecisionPhase()"]
    [eval exp="mp.battle.advancePhase()"]
    [jump target="*process_battle_events_start"]
*battle_heroine_action_decision_phase_start
    [turn_text msg="ヒロインアクション決定フェイズ"]
    [eval exp="mp.battle.processHeroineActionDecisionPhase()"]
    [eval exp="mp.battle.advancePhase()"]
    [jump target="*process_battle_events_start"]
*battle_resolution_phase_start
    [turn_text msg="解決フェイズ"]
    [eval exp="mp.battle.processResolutionPhase()"]
    [eval exp="mp.battle.advancePhase()"]
    [jump target="*process_battle_events_start"]
*battle_turn_end_phase_start
    [turn_text msg="クリンナップフェイズ"]
    [eval exp="mp.battle.processCleanUpPhase()"]
    [eval exp="mp.battle.advancePhase()"]
    [jump target="*process_battle_events_start"]

*chara_action_refresh
    [freeimage layer="4"]
    [chara_action_refresh charaDisps="&tf.currentEvent.params.enemies"]
    [chara_action_refresh charaDisps="&tf.currentEvent.params.heroines"]
    [jump target="*process_battle_events_start"]

*battle_enemy_damage_display
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="+=50" time="100" effect="easeInCirc"]
    [iscript]
        if (tf.currentEvent.params.amount > 0) {
            tf.currentEvent.params.target.charaInstance.pose = "damaged";
        }
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.target.charaInstance" time="100"][wa]
    [damage_to targetname="&tf.currentEvent.params.target.charaInstance.name" chara="&tf.currentEvent.params.target.charaInstance" damagevalue="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="-=50" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.target.charaInstance.updatePoseByLp();
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.target.charaInstance" time="100"][wa]
    [jump target="*process_battle_events_start"]
*battle_enemy_heal_display
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="+=50" time="100" effect="easeInCirc"][wa]
    [heal_to chara="&tf.currentEvent.params.target.charaInstance" healValue="&tf.currentEvent.params.amount" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="-=50" time="100" effect="easeInCirc"][wa]
    [jump target="*process_battle_events_start"]
*battle_enemy_guard_action
    [anim name="&tf.currentEvent.params.attacker.charaInstance.name" left="-=50" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.attacker.charaInstance.pose = "attack";
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.attacker.charaInstance" time="100"]
    [wa]
    [anim name="&tf.currentEvent.params.guardian.charaInstance.name" left="&tf.currentEvent.params.target.charaInstance.guardedX(tf.currentEvent.params.target.x)" top="&tf.currentEvent.params.target.charaInstance.guardedY(tf.currentEvent.params.target.y)" time="100"][wa]
    [guard_effect chara="&tf.currentEvent.params.target.charaInstance" x="&tf.currentEvent.params.target.charaInstance.guardedX(tf.currentEvent.params.target.x)" y="&tf.currentEvent.params.target.charaInstance.guardedY(tf.currentEvent.params.target.y)"]
    [anim name="&tf.currentEvent.params.guardian.charaInstance.name" left="&tf.currentEvent.params.guardian.x" top="&tf.currentEvent.params.guardian.y" time="50"]
    [wa]
    [anim name="&tf.currentEvent.params.attacker.charaInstance.name" left="+=50" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.attacker.charaInstance.updatePoseByLp();
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.attacker.charaInstance" time="100"]
    [wa]
    [jump target="*process_battle_events_start"]
*battle_enemy_er_apply_display
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="+=50" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.target.charaInstance.pose = "damaged";
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.target.charaInstance" time="100"][wa]
    [er_apply chara="&tf.currentEvent.params.target.charaInstance" erValue="&tf.currentEvent.params.amount" current="&tf.currentEvent.params.target.charaInstance.er" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="-=50" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.target.charaInstance.updatePoseByLp();
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.target.charaInstance" time="100"][wa]
    [jump target="*process_battle_events_start"]
*battle_enemy_enter_bundle
    [enemy_invisible enemy="&tf.currentEvent.params.source.charaInstance"]
    [heroine_hide heroine="&tf.currentEvent.params.target.charaInstance" time="0"]
    [bundle_display bundle="&tf.currentEvent.params.target.bundleInstance" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [focus_on_chara x="&tf.currentEvent.params.target.cameraX()" y="&tf.currentEvent.params.target.cameraY()"]
    [jump target="*process_battle_events_start"]
*battle_enemy_destroy
    [enemy_destroy enemy="&tf.currentEvent.params.enemy"]
    [jump target="*process_battle_events_start"]
*battle_heroine_leave_bundle
    [bundle_cancel bundle="&tf.currentEvent.params.heroine.bundleInstance"]
    [heroine_show heroine="&tf.currentEvent.params.heroine.charaInstance" left="&tf.currentEvent.params.heroine.x" top="&tf.currentEvent.params.heroine.y"]
    [enemy_visible enemy="&tf.currentEvent.params.enemy"]
    [eval exp="tf.currentEvent.params.heroine.leaveBundle()"]
    [jump target="*process_battle_events_start"]
*battle_heroine_bundle_damage
    [damage_to targetname="&tf.currentEvent.params.heroine.bundleInstance.name" chara="&tf.currentEvent.params.heroine.charaInstance" damagevalue="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [bundle_refresh bundle="&tf.currentEvent.params.heroine.bundleInstance" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_bundle_levelup
    [damage_to targetname="&tf.currentEvent.params.heroine.bundleInstance.name" chara="&tf.currentEvent.params.heroine.charaInstance" damagevalue="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [bundle_refresh bundle="&tf.currentEvent.params.heroine.bundleInstance" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [focus_on_chara x="&tf.currentEvent.params.heroine.cameraX()" y="&tf.currentEvent.params.heroine.cameraY()"]
    [jump target="*process_battle_events_start"]
*battle_heroine_er_change
    [er_change_to targetname="&tf.currentEvent.params.heroine.bundleInstance.name" chara="&tf.currentEvent.params.heroine.charaInstance" value="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_bundle_start_ecstasy
    [camera zoom="2" x="&tf.currentEvent.params.heroine.cameraX()" y="&tf.currentEvent.params.heroine.cameraY()" ease_type="ease-out" time="200"]
    [jump target="*process_battle_events_start"]
*battle_heroine_bundle_ecstasy
    [camera zoom="2" from_zoom="1" from_x="&tf.currentEvent.params.heroine.fromCameraX()" x="&tf.currentEvent.params.heroine.cameraX()" from_y="&tf.currentEvent.params.heroine.fromCameraY()" y="&tf.currentEvent.params.heroine.cameraY()" ease_type="ease-out" time="150"]
    [heroine_ecstasy bundle="&tf.currentEvent.params.heroine.bundleInstance" heroine="&tf.currentEvent.params.heroine" amount="&tf.currentEvent.params.amount" current="&tf.currentEvent.params.current"]
    [jump target="*process_battle_events_start"]
*battle_heroine_bundle_end_ecstasy
    [reset_camera ease_type="ease-in" time="50"]
    [eval exp="tf.currentEvent.params.heroine.setAfterBundle()"]
    [jump target="*process_battle_events_start"]
*battle_heroine_resist_bundle
    [bundle_shake bundle="&tf.currentEvent.params.heroine.bundleInstance"]
    [bundle_refresh bundle="&tf.currentEvent.params.heroine.bundleInstance" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_break_bundle
    [bundle_break_show bundle="&tf.currentEvent.params.heroine.bundleInstance" result="&tf.currentEvent.params.result" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [bundle_refresh bundle="&tf.currentEvent.params.heroine.bundleInstance" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_rescue_bundle
    [anim name="&tf.currentEvent.params.heroine.charaInstance.name" left="&tf.currentEvent.params.buddy.x" top="&tf.currentEvent.params.buddy.y" time="100"]
    [wa]
    [rescue_effect chara="&tf.currentEvent.params.buddy.charaInstance" x="&tf.currentEvent.params.buddy.x" y="&tf.currentEvent.params.buddy.y"]
    [anim name="&tf.currentEvent.params.heroine.charaInstance.name" left="&tf.currentEvent.params.heroine.x" top="&tf.currentEvent.params.heroine.y" time="50"]
    [wa]
    [spbar_refresh chara="&tf.currentEvent.params.heroine.charaInstance" x="&tf.currentEvent.params.heroine.x" y="&tf.currentEvent.params.heroine.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_damage_display
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="-=50" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.source.charaInstance.pose = "attack";
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.source.charaInstance" time="100"]
    [wa]
    [damage_to targetname="&tf.currentEvent.params.target.charaInstance.name" chara="&tf.currentEvent.params.target.charaInstance" damagevalue="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="+=50" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.source.charaInstance.updatePoseByLp();
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.source.charaInstance" time="100"]
    [wa]
    [jump target="*process_battle_events_start"]
*battle_heroine_damage_lambda_charge
    [image layer="8" name="lambda_charge" folder="fgimage" storage="chara/effects/LambdaCharge.webp" wait="false" left="&tf.currentEvent.params.target.x" top="&tf.currentEvent.params.target.y" width="&tf.currentEvent.params.target.charaInstance.width"]
    [damage_to targetname="&tf.currentEvent.params.target.charaInstance.name" chara="&tf.currentEvent.params.target.charaInstance" damagevalue="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [free layer="8" name="lambda_charge"]    
    [jump target="*process_battle_events_start"]
*battle_heroine_damage_guard_counter
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="&tf.currentEvent.params.target.x" top="&tf.currentEvent.params.target.y" time="100" effect="easeOutCirc"][wa]
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="&tf.currentEvent.params.source.x" top="&tf.currentEvent.params.source.y" time="200" effect="easeOutCirc"]
    [image layer="8" name="guard_damage" folder="fgimage" storage="chara/effects/HeroineGuard.webp" wait="false" left="&tf.currentEvent.params.target.x" top="&tf.currentEvent.params.target.y" width="&tf.currentEvent.params.target.charaInstance.width"]
    [wait time="150"]
    [free layer="8" name="guard_damage"]
    [damage_to targetname="&tf.currentEvent.params.target.charaInstance.name" chara="&tf.currentEvent.params.target.charaInstance" damagevalue="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_damage_mu_charge
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="&tf.currentEvent.params.target.x" top="&tf.currentEvent.params.target.y" time="100" effect="easeOutCirc"][wa]
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="&tf.currentEvent.params.source.x" top="&tf.currentEvent.params.source.y" time="200" effect="easeOutCirc"]
    [image layer="8" name="mucharge_damage" folder="fgimage" storage="chara/effects/MuCharge.webp" wait="false" left="&tf.currentEvent.params.target.x" top="&tf.currentEvent.params.target.y" width="&tf.currentEvent.params.target.charaInstance.width"]
    [wait time="150"]
    [free layer="8" name="mucharge_damage"]
    [damage_to targetname="&tf.currentEvent.params.target.charaInstance.name" chara="&tf.currentEvent.params.target.charaInstance" damagevalue="&tf.currentEvent.params.amount" split="&tf.currentEvent.params.split" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [jump target="*process_battle_events_start"]
*battle_heroine_heal_display
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="-=30" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.source.charaInstance.pose = "guard";
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.source.charaInstance" time="100"]
    [wa]
    [heal_to chara="&tf.currentEvent.params.target.charaInstance" healValue="&tf.currentEvent.params.amount" x="&tf.currentEvent.params.target.x" y="&tf.currentEvent.params.target.y"]
    [anim name="&tf.currentEvent.params.source.charaInstance.name" left="+=30" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.source.charaInstance.updatePoseByLp();
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.source.charaInstance" time="100"]
    [jump target="*process_battle_events_start"]
*battle_heroine_guard_action
    [anim name="&tf.currentEvent.params.attacker.charaInstance.name" left="+=30" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.guardian.charaInstance.pose = "guard";
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.guardian.charaInstance" time="100"]
    [wa]
    [anim name="&tf.currentEvent.params.guardian.charaInstance.name" left="&tf.currentEvent.params.target.charaInstance.guardedX(tf.currentEvent.params.target.x)" top="&tf.currentEvent.params.target.charaInstance.guardedY(tf.currentEvent.params.target.y)" time="100"][wa]
    [guard_effect chara="&tf.currentEvent.params.target.charaInstance" x="&tf.currentEvent.params.target.charaInstance.guardedX(tf.currentEvent.params.target.x)" y="&tf.currentEvent.params.target.charaInstance.guardedY(tf.currentEvent.params.target.y)"]
    [anim name="&tf.currentEvent.params.guardian.charaInstance.name" left="&tf.currentEvent.params.guardian.x" top="&tf.currentEvent.params.guardian.y" time="50"]
    [wa]
    [anim name="&tf.currentEvent.params.attacker.charaInstance.name" left="-=30" time="100" effect="easeInCirc"]
    [iscript]
        tf.currentEvent.params.guardian.charaInstance.updatePoseByLp();
    [endscript]
    [heroine_mod heroine="&tf.currentEvent.params.guardian.charaInstance" time="100"]
    [wa]
    [jump target="*process_battle_events_start"]
*battle_heroine_erbar_refresh
    [er_apply chara="&tf.currentEvent.params.source.charaInstance" erValue="&tf.currentEvent.params.amount" current="&tf.currentEvent.params.current" x="&tf.currentEvent.params.source.x" y="&tf.currentEvent.params.source.y"]
    [if exp="!tf.currentEvent.params.source.charaInstance.bundled"]
        [heroine_mod heroine="&tf.currentEvent.params.source.charaInstance" time="100"]
        [wa]
    [endif]
    [jump target="*process_battle_events_start"]
*battle_heroine_action_decision
    [image layer="5" storage="chara/actions/action_icon_graph.png" left="592" top="96" width="96" height="96"]
    [heroine_action_decision heroine="&tf.currentEvent.params.source" buddy="&tf.currentEvent.params.buddy" enemies="&tf.currentEvent.params.enemies"]
    [freeimage layer="5"]
    [jump target="*process_battle_events_start"]
*battle_heroine_enable_buddy_bonding
    [image layer="8" name="bonding" folder="fgimage" storage="chara/effects/BuddyBonding.webp" left="&tf.currentEvent.params.heroine.x" top="&tf.currentEvent.params.heroine.y" width="&tf.currentEvent.params.heroine.charaInstance.width"]
    [wait time="500"]
    [free layer="8" name="bonding"]
    [jump target="*process_battle_events_start"]
*battle_lambda_lightning_sunday
    [lightning_sunday lambda_disp="&tf.currentEvent.params.source" amount="&tf.currentEvent.params.amount" enemies="&tf.currentEvent.params.enemies"]
    [jump target="*process_battle_events_start"]
*battle_mu_adrenaline_rush
    [adrenaline_rush mu_disp="&tf.currentEvent.params.source" amount="&tf.currentEvent.params.amount"]
    [jump target="*process_battle_events_start"]
    
*battle_chara_spbar_refresh
    [spbar_refresh chara="&tf.currentEvent.params.source.charaInstance" x="&tf.currentEvent.params.source.x" y="&tf.currentEvent.params.source.y"]
    [jump target="*process_battle_events_start"]

*battle_win
    [layopt layer="2" visible="false"]
    [layopt layer="3" visible="false"]
    [layopt layer="4" visible="false"]
    [layopt layer="5" visible="false"]
    [layopt layer="6" visible="false"]
    [layopt layer="7" visible="false"]
    [layopt layer="8" visible="false"]
    [layopt layer="9" visible="false"]
    [turn_text msg="！！勝利！！"]
    [anim name="&tf.currentEvent.params.lambda.charaInstance.name" left="500" top="150"]
    [anim name="&tf.currentEvent.params.mu.charaInstance.name" left="740" top="150"]
    [wa]
    [jump target="*process_battle_events_start"]
*battle_lose
    [layopt layer="2" visible="false"]
    [layopt layer="3" visible="false"]
    [layopt layer="4" visible="false"]
    [layopt layer="5" visible="false"]
    [layopt layer="6" visible="false"]
    [layopt layer="7" visible="false"]
    [layopt layer="8" visible="false"]
    [layopt layer="9" visible="false"]
    [turn_text msg="全滅しました・・・。"]
    [anim name="&tf.currentEvent.params.lambda.charaInstance.name" left="500" top="150"]
    [anim name="&tf.currentEvent.params.mu.charaInstance.name" left="740" top="150"]
    [wa]
    [jump target="*process_battle_events_start"]
*battle_end_sequence
    [arena_end_button target="*back_to_menu"][s]

*process_battle_events_end
[endmacro]

[macro name="battle_init"]
    [process_battle_events battle="&mp.battle"]
[endmacro]
[macro name="battle_loop"]
*battle_loop_start
    [jump target="*battle_loop_end" cond="mp.battle.checkBattleEndCondition()"]
    [process_battle_events battle="&mp.battle"]
    [jump target="*battle_loop_start"]
*battle_loop_end
[endmacro]
[return]