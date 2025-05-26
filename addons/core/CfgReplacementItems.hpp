// This config accepts both item type numbers and item class names
// Item type numbers need the prefix ItemType_, so for example ItemType_401
// Class names need no special prefix
class ACEGVAR(medical,replacementItems) {
    DOUBLES(ItemType,TYPE_FIRST_AID_KIT)[] = {
        {"ACM_PressureBandage", 2},
        {"ACE_tourniquet", 1},
        {"ACM_ChestSeal", 1},
        {"ACM_NPA", 1},
        {"ACM_Paracetamol",1}
    };
    DOUBLES(ItemType,TYPE_MEDIKIT)[] = {
        {"ACM_PressureBandage", 3},
        {"ACM_ElasticWrap", 5},
        {"ACM_Vial_Morphine", 1},
        {"ACM_Syringe_5", 1},
        {"ACE_salineIV_250", 1},
        {"ACE_tourniquet", 1},
        {"ACM_SAMSplint", 2},
        {"ACM_ChestSeal", 1},
        {"ACM_NPA", 1},
        {"ACM_NCDKit", 1},
        {"ACM_SuctionBag", 1},
        {"ACM_IV_16g", 1}
    };
};
