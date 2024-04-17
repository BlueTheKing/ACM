class ACE_bloodIV: ACE_ItemCore {
    //scope = 0;
};
class ACM_BloodBag_O_1000: ACE_bloodIV {
    scope = 2;
    author = "Blue";
    displayName = "Blood Bag O+ (1000ml)";
    descriptionShort = "Used to replenish lost blood volume";
    descriptionUse = "Blood bag used to replenish lost blood volume";
};

#define BLOODBAG_ENTRY(type,typeS,amount) \
    class TRIPLES(ACM_BloodBag,type,amount): DOUBLES(ACM_BloodBag_O,amount) { \
        displayName = QUOTE(Blood Bag typeS (##amount##ml)); \
    }

BLOODBAG_ENTRY(ON,O-,1000);
BLOODBAG_ENTRY(A,A+,1000);
BLOODBAG_ENTRY(AN,A-,1000);
BLOODBAG_ENTRY(B,B+,1000);
BLOODBAG_ENTRY(BN,B-,1000);
BLOODBAG_ENTRY(AB,AB+,1000);
BLOODBAG_ENTRY(ABN,AB-,1000);

class ACE_bloodIV_500: ACE_bloodIV {
    //scope = 0;
};
class ACM_BloodBag_O_500: ACE_bloodIV_500 {
    scope = 2;
    author = "Blue";
    displayName = "Blood Bag O+ (500ml)";
    descriptionShort = "Used to replenish lost blood volume";
    descriptionUse = "Blood bag used to replenish lost blood volume";
};

BLOODBAG_ENTRY(ON,O-,500);
BLOODBAG_ENTRY(A,A+,500);
BLOODBAG_ENTRY(AN,A-,500);
BLOODBAG_ENTRY(B,B+,500);
BLOODBAG_ENTRY(BN,B-,500);
BLOODBAG_ENTRY(AB,AB+,500);
BLOODBAG_ENTRY(ABN,AB-,500);

class ACE_bloodIV_250: ACE_bloodIV {
    //scope = 0;
};
class ACM_BloodBag_O_250: ACE_bloodIV_250 {
    scope = 2;
    author = "Blue";
    displayName = "Blood Bag O+ (250ml)";
    descriptionShort = "Used to replenish lost blood volume";
    descriptionUse = "Blood bag used to replenish lost blood volume";
};

BLOODBAG_ENTRY(ON,O-,250);
BLOODBAG_ENTRY(A,A+,250);
BLOODBAG_ENTRY(AN,A-,250);
BLOODBAG_ENTRY(B,B+,250);
BLOODBAG_ENTRY(BN,B-,250);
BLOODBAG_ENTRY(AB,AB+,250);
BLOODBAG_ENTRY(ABN,AB-,250);