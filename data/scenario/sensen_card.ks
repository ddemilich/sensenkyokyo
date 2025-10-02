*start
; カードクラス
[iscript]
class SensenCard {
    static rank = 0;
    constructor(id, name, heroine, buddy) {
        this.id = id;
        this.name = name;
        this.heroine = heroine;
        this.buddy = buddy;
    }
    getCardText() {
        return `${this.name}<br /><br />${this.getText()}`;
    }
    getText() {
        // カードの説明
        return `${this.heroine.displayName}用カード。<br />特に効果なし。`;
    }
    getRank() {
        return this.constructor.rank; 
    }
    getButtonColor() {
        const rank = this.getRank(); 
        switch (rank) {
            case 1:
                return "btn_29_green";
            case 2:
                return "btn_29_blue";
            case 3:
                return "btn_29_purple";
            case 4:
                return "btn_29_red";
            default:
                return "btn_29_green";
        }
    }

    apply() {
        // 効果の適用
        return;
    }
}
// RANK1 START
class HeroineApUpCard extends SensenCard {
    static rank = 1;
    constructor(heroine, buddy) {
        super(1, `攻撃Up小`, heroine, buddy);
    }
    getText() {
        return `${this.heroine.displayName}の攻撃力を2~5上昇させる。`;
    }
    apply() {
        this.heroine.ap.increaseBaseValue(BattleUtil.getRandomInt(2, 5));
    }
}
window.HeroineApUpCard = HeroineApUpCard;

class HeroineCooldownCard extends SensenCard {
    static rank = 1;
    constructor(heroine, buddy) {
        super(2, `クールダウン`, heroine, buddy);
        this.rank=1;
    }
    getText() {
        return `${this.heroine.displayName}の快楽値を半分にし、最大体力を2増加させる。`;
    }
    apply() {
        let amount = Math.floor(this.heroine.er / 2);
        this.heroine.changeEr(-amount);
        this.heroine.maxLp += 2;
    }
}
window.HeroineCooldownCard = HeroineCooldownCard;

class HeroineMeditateCard extends SensenCard {
    static rank = 1;
    constructor(heroine, buddy) {
        super(3, `冷静沈着`, heroine, buddy);
    }
    getText() {
        return `${this.heroine.displayName}の快楽値を半分にし、攻撃力を1増加させる。`;
    }
    apply() {
        let amount = Math.floor(this.heroine.er / 2);
        this.heroine.changeEr(-amount);
        this.heroine.ap.increaseBaseValue(1);
    }
}
window.HeroineMeditateCard = HeroineMeditateCard;

class HeroineLpUpCard extends SensenCard {
    static rank = 1;
    constructor(heroine, buddy) {
        super(4, `体力Up小`, heroine, buddy);
    }
    getText() {
        return `${this.heroine.displayName}の最大体力を3~6上昇させる。`;
    }
    apply() {
        this.heroine.maxLp += BattleUtil.getRandomInt(3, 6);
    }
}
window.HeroineLpUpCard = HeroineLpUpCard;

// RANK2 START
class HeroineRebalanceCard extends SensenCard {
    static rank = 2;
    constructor(heroine, buddy) {
        super(20, `リバランス`, heroine, buddy);
    }
    getText() {
        return `${this.heroine.displayName}の最大体力を7~13上昇させる。<br />代償として${this.buddy.displayName}の最大体力を10%減少させる。`;
    }
    apply() {
        this.heroine.maxLp += BattleUtil.getRandomInt(7, 13);
        let value = Math.floor(this.buddy.maxLp * 0.1);
        if (value > 0) {
            this.buddy.maxLp -= value;
            if(this.buddy.lp > this.buddy.maxLp) {
                this.buddy.lp = this.buddy.maxLp;
            }
        }
    }
}
window.HeroineRebalanceCard = HeroineRebalanceCard;

class HeroineLoversCard extends SensenCard {
    static rank = 2;
    constructor(heroine, buddy) {
        super(21, `一緒に・・・しよ？`, heroine, buddy);
    }
    getText() {
        return `${this.heroine.displayName}と${this.buddy.displayName}の最大体力を6~11上昇させる。<br />代償として${this.heroine.displayName}と${this.buddy.displayName}の快楽値を30上昇させる。`;
    }
    apply() {
        this.heroine.maxLp += BattleUtil.getRandomInt(6, 11);
        this.buddy.maxLp += BattleUtil.getRandomInt(6, 11);
        this.heroine.changeEr(30);
        this.buddy.changeEr(30);
    }
}
window.HeroineLoversCard = HeroineLoversCard;

class HeroineBerserkCard extends SensenCard {
    static rank = 2;
    constructor(heroine, buddy) {
        super(23, `バーサーク`, heroine, buddy);
    }
    getText() {
        return `${this.heroine.displayName}の攻撃力を5~10上昇させる。<br />代償として${this.heroine.displayName}の最大体力を10%減少させる。`;
    }
    apply() {
        this.heroine.ap.increaseBaseValue(BattleUtil.getRandomInt(5, 10));
        let value = Math.floor(this.heroine.maxLp * 0.1);
        if (value > 0) {
            this.heroine.maxLp -= value;
            if(this.heroine.lp > this.heroine.maxLp) {
                this.heroine.lp = this.heroine.maxLp;
            }
        }
    }
}
window.HeroineBerserkCard = HeroineBerserkCard;

// RANK3 START

class HeroineDopingCard extends SensenCard {
    static rank = 3;
    constructor(heroine, buddy) {
        super(40, `ドーピング`, heroine, buddy);
        this.rank=3;
    }
    getText() {
        return `${this.heroine.displayName}の攻撃力を1~20上昇させる。<br />代償として${this.heroine.displayName}の上昇した攻撃力の20倍の快楽値を上昇させる。`;
    }
    apply() {
        let amount = BattleUtil.getRandomInt(1, 20);
        this.heroine.ap.increaseBaseValue(amount);
        this.heroine.changeEr(20 * amount);
    }
}
window.HeroineDopingCard = HeroineDopingCard;

class HeroineWonderingSweetCard extends SensenCard {
    static rank = 3;
    constructor(heroine, buddy) {
        super(41, `不思議なお菓子`, heroine, buddy);
        this.rank=3;
    }
    getText() {
        return `${this.heroine.displayName}の最大体力を5~10%上昇させる。<br />代償として${this.heroine.displayName}の快楽値を50上昇させる。`;
    }
    apply() {
        this.heroine.maxLp += (Math.floor((100+BattleUtil.getRandomInt(5, 10))/100));
        this.heroine.changeEr(50);
    }
}
window.HeroineWonderingSweetCard = HeroineWonderingSweetCard;

// RANK4 START
class HeroineForbiddenFruitCard extends SensenCard {
    static rank = 4;
    constructor(heroine, buddy) {
        super(60, `禁断の果実`, heroine, buddy);
    }
    getText() {
        return `${this.heroine.displayName}のアクション回数を1回増やす。<br />代償として${this.heroine.displayName}の堕落値を30上昇させる。`;
    }
    apply() {
        this.heroine.maxActionCount.increaseBaseValue(1);
        this.heroine.changeCr(30);
    }
}
window.HeroineForbiddenFruitCard = HeroineForbiddenFruitCard;

[endscript]
[return]