*start
; イベントクラスと表示ブロック
[iscript]
class SensenStageEvent {
    constructor(progress) {
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 0;

        if (Math.random() * 100 < progress * 0.2) {
            this.hasBattle = false;
        }
        if (this.hasBattle) {
            if (Math.random() * 100 < progress * 0.8) {
                this.isBig = true;
            }
            if (this.isBig) {
                this.enemyCount = BattleUtil.getRandomInt(5, 6);
            } else {
                this.enemyCount = BattleUtil.getRandomInt(2, 4);
            }
        } else {
            if (Math.random() * 100 < progress * 0.5) {
                this.isBig = true;
            }
        }
        if (Math.random() * 100 < progress * 0.5) {
            this.hasTrap = true;
            if (Math.random() * 100 < progress * 0.8) {
                this.isBigTrap = true;
            }
        }
    }

    getProgressPoint() {
        let point = 0;
        // 戦闘有: 9 無: 4
        if (this.hasBattle) {
            point = 9;
            // 戦闘規模: +敵の数
            point += this.enemyCount;
        } else {
            point = 4;
            // 小回復: +7
            // 大回復: +10
            if (this.isBig) {
                point += 10;
            } else {
                point += 7;
            }
        }
        // 罠有: +5
        if (this.hasTrap) {
            point += 5;
        }
        return point;
    }

    getImagePath() {
        let prefix = "eventBattle";
        let suffix = "";

        if (!this.hasBattle) {
            prefix = "eventHeal";
        }
        if (this.isBig) {
            prefix += "Big";
        }
        if (this.hasTrap) {
            suffix = "_trap";
        }
        if (this.isBigTrap) {
            suffix += "Big";
        }
        return `eventButton/${prefix}${suffix}.png`;
    }

    detail() {
        let msg = "敵との戦闘になる。<br />少数の敵２～４体と戦う。<br />";
        if (this.hasBattle) {
            if (this.isBig) {
                msg = "敵との激しい戦闘になる。<br />多数の敵５～６体と戦う。<br />";
            }
        } else {
            if (this.isBig) {
                msg = "ゆっくり休憩しよう。<br />最大体力の５０%回復する。<br />";
            } else {
                msg = "少し休憩しよう。<br />最大体力の５０%回復する。<br />"
            }
        }
        if (this.hasTrap) {
            if (this.isBigTrap) {
                msg += "とても嫌な予感がする。<br />";
            } else {
                msg += "何か様子がおかしい。<br />";
            }
        }
        return msg;
    }

    apply(lambda, mu) {
        let msg = "";
        let oldValue = 0;
        let addValue = 0;
        if (!this.hasBattle) {
            // 回復処理
            if (this.isBig) {
                msg = "安全な場所でゆっくり休憩した...<br >";

                oldValue = lambda.lp;
                addValue = Math.floor(lambda.maxLp * 0.5);
                lambda.heal(addValue);
                msg += `　ラムダの体力が回復した。${oldValue}->${lambda.lp}<br />`;

                oldValue = mu.lp;
                addValue = Math.floor(mu.maxLp * 0.5);
                mu.heal(addValue);
                msg += `　ミューの体力が回復した。${oldValue}->${mu.lp}<br />`;
            } else {
                msg = "少し休憩した...<br >";

                oldValue = lambda.lp;
                addValue = Math.floor(lambda.maxLp * 0.2);
                lambda.heal(addValue);
                msg += `　ラムダの体力が回復した。${oldValue} -> ${lambda.lp}<br />`;

                oldValue = mu.lp;
                addValue = Math.floor(mu.maxLp * 0.2);
                mu.heal(addValue);
                msg += `　ミューの体力が回復した。${oldValue} -> ${mu.lp}<br />`;
            }
        }
        if (this.hasTrap) {
            let lambdaTrapped = false;
            let muTrapped = false;
            // 罠の処理
            // まずラムダとミューの回避判定を行う
            let lresult = lambda.applyDamageWithEvasion([1]);
            if (lresult.actualTotalDamage > 0) {
                // 命中
                lambdaTrapped = true;
            }
            let mresult = mu.applyDamageWithEvasion([1]);
            if (mresult.actualTotalDamage > 0) {
                // 命中
                muTrapped = true;
            }
            if (this.isBigTrap) {
                msg += "怪しい液体が降り注ぐ！<br />";
                if (lambdaTrapped) {
                    oldValue = lambda.er;
                    lambda.applyErValue(50);
                    msg += `　ラムダは全身に液体を浴びてしまった。快楽値：${oldValue} -> ${lambda.er}<br />`;
                } else {
                    msg += `　ラムダは素早く回避した。<br />`;
                }
                if (muTrapped) {
                    oldValue = mu.er;
                    mu.applyErValue(50);
                    msg += `　ミューは全身に液体を浴びてしまった。快楽値：${oldValue} -> ${mu.er}<br />`;
                } else {
                    msg += `　ミューは素早く回避した。<br />`;
                }
            } else {
                msg += "怪しいガスが噴き出した！<br />";
                if (lambdaTrapped) {
                    oldValue = lambda.er;
                    lambda.applyErValue(25);
                    msg += `　ラムダはガスを吸い込んでしまった。快楽値：${oldValue} -> ${lambda.er}<br />`;
                } else {
                    msg += `　ラムダは素早く回避した。<br />`;
                }
                if (muTrapped) {
                    oldValue = mu.er;
                    mu.applyErValue(25);
                    msg += `　ミューはガスを吸い込んでしまった。快楽値：${oldValue} -> ${mu.er}<br />`;
                } else {
                    msg += `　ミューは素早く回避した。<br />`;
                }
            }
        }
        this.eventMsg = msg;
    }

    generateEnemyIdList(uniqueEnemyIds) {
        let generated = [];
        if (!this.hasBattle) {
            return generated;
        }

        const maxIndex = uniqueEnemyIds.length - 1;

        for (let i = 0; i < this.enemyCount; i++) {
            const randomIndex = BattleUtil.getRandomInt(0, maxIndex); 
            generated.push(uniqueEnemyIds[randomIndex]);
        }
        return generated;
    }

    getDefaultSp() {
        return 0;
    }
    getActionWeight() {
        return [4,2,1];
    }
}
window.SensenStageEvent = SensenStageEvent;

class SensenStageBossEvent extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 6;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventBoss.png";
    }
    detail() {
        let msg = "ステージボス「マウント」との戦闘になる。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        let generated = super.generateEnemyIdList(["e13"]);
        // 一番最後にマウントを設定
        generated[generated.length-1] = "e14";
        return generated;
    }
}
window.SensenStageBossEvent = SensenStageBossEvent;

class SensenStageBossEventTwo extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 6;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventBoss.png";
    }
    detail() {
        let msg = "ステージボス「バインド」との戦闘になる。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        let generated = super.generateEnemyIdList(["e23"]);
        // 一番最後にバインドを設定
        generated[generated.length-1] = "e24";
        return generated;
    }
}
window.SensenStageBossEventTwo = SensenStageBossEventTwo;

class SensenStageFixedEventE11 extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 4;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventFixed.png";
    }
    detail() {
        let msg = "騒がしい声が聞こえる。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        return super.generateEnemyIdList(["e11"]);
    }
    getDefaultSp() {
        return 75;
    }
    getActionWeight() {
        return [0,0,1];
    }
}
window.SensenStageFixedEventE11 = SensenStageFixedEventE11;

class SensenStageFixedEventE12 extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 4;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventFixed.png";
    }
    detail() {
        let msg = "クスクスと笑う女性の声がする。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        return super.generateEnemyIdList(["e12"]);
    }
    getDefaultSp() {
        return 75;
    }
    getActionWeight() {
        return [0,1,0];
    }
}
window.SensenStageFixedEventE12 = SensenStageFixedEventE12;

class SensenStageFixedEventE13 extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 4;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventFixed.png";
    }
    detail() {
        let msg = "ボイラーの熱気を感じる。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        return super.generateEnemyIdList(["e13"]);
    }
    getDefaultSp() {
        return 25;
    }
    getActionWeight() {
        return [1,0,0];
    }
}
window.SensenStageFixedEventE13 = SensenStageFixedEventE13;

class SensenStageFixedEventE21 extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 2;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventFixed.png";
    }
    detail() {
        let msg = "勇ましい訓練の掛け声が聞こえる。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        return super.generateEnemyIdList(["e21"]);
    }
    getDefaultSp() {
        return 100;
    }
    getActionWeight() {
        return [1,1,0];
    }
}
window.SensenStageFixedEventE21 = SensenStageFixedEventE21;

class SensenStageFixedEventE22 extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 3;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventFixed.png";
    }
    detail() {
        let msg = "タッタッタと規則正しく走る音がする。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        return super.generateEnemyIdList(["e22"]);
    }
    getDefaultSp() {
        return 100;
    }
    getActionWeight() {
        return [0,1,1];
    }
}
window.SensenStageFixedEventE22 = SensenStageFixedEventE22;

class SensenStageFixedEventE23 extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
        this.enemyCount = 4;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventFixed.png";
    }
    detail() {
        let msg = "キチキチと関節のこすれる音がする。<br />";
        return msg;
    }
    generateEnemyIdList(uniqueEnemyIds) {
        return super.generateEnemyIdList(["e23"]);
    }
    getDefaultSp() {
        return 100;
    }
    getActionWeight() {
        return [1,0,1];
    }
}
window.SensenStageFixedEventE23 = SensenStageFixedEventE23;
[endscript]
[return]