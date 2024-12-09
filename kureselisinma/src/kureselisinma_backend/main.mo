import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Time "mo:base/Time";

actor GlobalWarmingAwareness {
    // Gelişmiş Küresel Isınma İstatistikleri Yapısı
    public type GlobalWarmingStatistic = {
        id : Nat;
        title : Text;
        description : Text;
        impact : Text;
        severity : Nat8; // 1-10 arası şiddet seviyesi (daha güvenli tip)
        year : Nat16; // Daha spesifik yıl tipi
    };

    // Kullanıcı Yorumu Yapısı
    public type UserComment = {
        id : Nat;
        content : Text;
        timestamp : Int;
    };

    // Küresel Isınma İstatistikleri Veritabanı
    private var statisticsDB : HashMap.HashMap<Nat, GlobalWarmingStatistic> = HashMap.HashMap<Nat, GlobalWarmingStatistic>(10, Nat.equal, Hash.hash);

    // Kullanıcı Yorumları Veritabanı
    private var commentsDB : HashMap.HashMap<Nat, UserComment> = HashMap.HashMap<Nat, UserComment>(10, Nat.equal, Hash.hash);

    // Güvenli İstatistik Ekleme Fonksiyonu
    public func addStatistic(statistic : GlobalWarmingStatistic) : async Result.Result<(), Text> {
        if (statistic.severity > 10) {
            return #err("Şiddet seviyesi 10'dan büyük olamaz");
        };

        if (Text.size(statistic.title) == 0) {
            return #err("Başlık boş bırakılamaz");
        };

        statisticsDB.put(statistic.id, statistic);
        return #ok();
    }

    // Çarpıcı İstatistikler Listesi
    private func initializeStatistics() : async () {
        let devastatingFacts : [var GlobalWarmingStatistic] = [
            {
                id = 1;
                title = "Buz Örtüsü Yok Oluyor";
                description = "Arktik buz örtüsü son 40 yılda %40 oranında azaldı. Bu durum, gezegenimizdeki en kritik ekosistemlerin çökmesi anlamına geliyor.";
                impact = "Kutup ayıları ve diğer Arctic canlıları için varoluşsal tehdit";
                severity = 9;
                year = 2023;
            },
            {
                id = 2;
                title = "Okyanus Asitleşmesi";
                description = "Atmosferdeki artan CO2 oranları, okyanus sularının asitlik seviyesini son 300 milyon yılın en yüksek düzeyine çıkardı.";
                impact = "Mercan resiflerinin %70'i yok olma tehlikesiyle karşı karşıya";
                severity = 8;
                year = 2022;
            },
            {
                id = 3;
                title = "Aşırı Hava Olayları";
                description = "Son 20 yılda aşırı hava olaylarının sıklığı ve şiddeti %500 oranında arttı.";
                impact = "Milyonlarca insanın yaşam alanları tehlike altında";
                severity = 10;
                year = 2024;
            },
            {
                id = 4;
                title = "Deniz Seviyesi Yükselişi";
                description = "Küresel deniz seviyeleri son 100 yılda 20 cm yükseldi ve bu yükseliş hızlanarak devam ediyor.";
                impact = "Kıyı şehirleri ve adaların sular altında kalma riski";
                severity = 7;
                year = 2023;
            }
        ];

        for (fact in devastatingFacts.vals()) {
            await addStatistic(fact); // await eklendi
        };
    }

    // Tüm İstatistikleri Getir
    public query func getAllStatistics() : async [GlobalWarmingStatistic] {
        return Array.fromHashMap(statisticsDB);
    }



    // En Şiddetli İstatistikleri Getir
    public query func getMostSevereStatistics() : async [GlobalWarmingStatistic] {
         return Array.fromHashMap(statisticsDB).filter(func(stat : GlobalWarmingStatistic) : Bool {
            return stat.severity >= 8;
        });
    }

    // Gelişmiş Kullanıcı Yorumu Ekleme
    public func addUserComment(comment : Text) : async Result.Result<Nat, Text> {
        if (Text.size(comment) == 0) {
            return #err("Yorum boş bırakılamaz");
        };

        if (Text.size(comment) > 500) {
            return #err("Yorum 500 karakterden uzun olamaz");
        };

        let commentId = commentsDB.size() + 1;
        let newComment : UserComment = {
            id = commentId;
            content = comment;
            timestamp = Time.now(); // Şu anki zaman bilgisini ekle
        };

        commentsDB.put(commentId, newComment);
        return #ok(commentId);
    }

    // Sistemin başlatılması
    public func init() : async () {
        await initializeStatistics();
    }
}