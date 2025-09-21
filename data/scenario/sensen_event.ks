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
        if (Math.random() * 100 < progress * 0.8) {
            this.isBigTrap = true;
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
}
[endscript]
[return]