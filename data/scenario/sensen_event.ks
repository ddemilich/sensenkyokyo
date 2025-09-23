*start
; イベントクラスと表示ブロック
[iscript]
class SensenStageEvent {
    constructor(progress) {
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;

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
                msg = "ゆっくり休憩しよう。<br />最大LPを10%上昇させる。その後最大LPの50%回復する。<br />";
            } else {
                msg = "少し休憩しよう。<br />最大LPを5%上昇させる。その後最大LPの20%回復する。<br />"
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
}
window.SensenStageEvent = SensenStageEvent;

class SensenStageBossEvent extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
    }
    getProgressPoint() {
        return 0;
    }
    getImagePath() {
        return "eventButton/eventBoss.png";
    }
    detail() {
        let msg = "ステージボスとの戦闘になる。<br />";
        return msg;
    }
}
window.SensenStageBossEvent = SensenStageBossEvent;

class SensenStageFixedEvent extends SensenStageEvent {
    constructor(progress) {
        super(progress);
        this.hasBattle = true;
        this.hasTrap = false;
        this.isBig = false;
        this.isBigTrap = false;
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
}
window.SensenStageFixedEvent = SensenStageFixedEvent;
[endscript]
[return]