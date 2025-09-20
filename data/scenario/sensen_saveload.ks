*start
; f:  システム変数
;   ゲーム全体で共有する変数です。
;   例えば、「エンディングを見たことがあるか否か」といったセーブデータに影響されない内容を保存します。
; sf: ゲーム変数
;   セーブデータ毎に管理する変数です。
;   他のセーブデータが呼び出されると上書きされます。 
;   例えば、「アイテム管理」や「どの選択肢を選んだか」といったゲームの進行に関わるデータを保存します
; tf: 一時変数
;   一時的に使用するデータを保存します。ゲームを再開しても復元されません。
[iscript]
class SensenSystemData {
    constructor(firstLaunchTimestamp = Date.now()) {
        this.firstLaunchTimestamp = firstLaunchTimestamp;
        this.clearCount = 0;
        this.unlockedEndings = {};
        this.unlockedExtraContent = {};
        this.monsterEncyclopedia = {};
        // 他に将来追加するデータがあればここに定義
    }
    
    getFirstLaunchDateString() {
        const date = new Date(this.firstLaunchTimestamp);
        return date.toLocaleString('ja-JP', {
            timeZone: 'Asia/Tokyo',
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: false
        });
    }
}

class SensenData {
    constructor(lambda, lcards, mu, mcards) {
        this.lambda = lambda;
        this.mu = mu;
        this.lambda_cards = lcards;
        this.mu_cards = mcards;
    }
}

class SensenSaveData {
    constructor(sensenData=null) { 
        let lambda;
        let mu;

        if (sensenData) {
            lambda = sensenData.lambda;
            mu = sensenData.mu;
        } else {
            lambda = new HeroineLambda(300, 50);
            mu = new HeroineMu(300, 50);
        }

        // 基礎ステータス
        this.lambda_maxLp = lambda.maxLp;
        this.lambda_ap = lambda.ap.baseValue;
        this.mu_maxLp = lambda.maxLp;
        this.mu_ap = lambda.ap.baseValue;
        // その他ステータス
        this.lambda_cr = lambda.cr;
        this.lambda_actionCount = lambda.maxActionCount.baseValue;
        this.mu_cr = mu.cr;
        this.mu_actionCount = lambda.maxActionCount.baseValue;
        // カード
        this.lambda_card_ids = [];
        this.mu_card_ids = [];
    }
    serialize() {
        return JSON.parse(JSON.stringify(this));
    }

    extract() {
        // 基礎ステータスをコンストラクタに
        let lambda = new HeroineLambda(this.lambda_maxLp, this.lambda_ap);
        let mu = new HeroineMu(this.mu_maxLp, this.mu_ap);
        // その他ステータスを適用
        lambda.cr = this.lambda_cr;
        lambda.maxActionCount.baseValue = this.lambda_actionCount;
        mu.cr = this.mu_cr;
        mu.maxActionCount.baseValue = this.mu_actionCount;
        // TODO: カードIDからカードインスタンスを作る
        return new SensenData(lambda, mu, [], []);
    }

    static deserialize(plainObject) {
        // 新しいクラスインスタンスを生成
        const instance = new SensenSaveData();

        // プレーンなオブジェクトのプロパティを新しいインスタンスにコピー
        Object.assign(instance, plainObject);

        return instance;
    }
}
window.SensenSaveData = SensenSaveData;

// システムデータがすでに初期化されているかチェックする
if (f.sensenSystemData === undefined) {
    console.log("JS: SENSENKYOKYOシステムデータを初期化します。");
    // クラスの新しいインスタンスでシステムデータを初期化
    f.sensenSystemData = new SensenSystemData();
}

[endscript]

[macro name="sensen_init"]
    [iscript]
        let saveData = new SensenSaveData();
        sf.sensenSaveData = saveData.serialize();
    [endscript]
[endmacro]
[macro name="sensen_load"]
    [iscript]
        if (sf.sensenSaveData) {
            let saveData = SensenSaveData.deserialize(sf.sensenSaveData);
            tf.sensenData = saveData.extract();
        }
        console.log(`${tf.sensenData.lambda.name}`);
        console.log(`${tf.sensenData.lambda.currentAp}`);
        console.log(`${tf.sensenData.mu.name}`);
        console.log(`${tf.sensenData.mu.currentAp}`);
    [endscript]
[endmacro]
[macro name="sensen_save"]
    [iscript]
        sf.sensenSaveData = new SensenSaveData(tf.sensenData).serialize();
    [endscript]
[endmacro]
[return]