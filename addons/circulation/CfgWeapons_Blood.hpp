#define BLOODBAG_NAME_FORMAT(string) QUOTE(format [ARR_2(C_LLSTRING(BloodBag),string)])

class ACE_bloodIV: ACE_ItemCore {
    scope = 1;
};
class ACM_BloodBag_O_1000: ACE_bloodIV {
    scope = 2;
    author = "Blue";
    displayName = __EVAL(call compile BLOODBAG_NAME_FORMAT('O+ (1000ml)'));
    descriptionShort = CSTRING(BloodBag_Desc);
};

#define BLOODBAG_ENTRY(type,amount,name) \
    class TRIPLES(ACM_BloodBag,type,amount): DOUBLES(ACM_BloodBag_O,amount) { \
        displayName = name; \
    }

BLOODBAG_ENTRY(ON,1000,__EVAL(call compile BLOODBAG_NAME_FORMAT('O- (1000ml)')));
BLOODBAG_ENTRY(A,1000,__EVAL(call compile BLOODBAG_NAME_FORMAT('A+ (1000ml)')));
BLOODBAG_ENTRY(AN,1000,__EVAL(call compile BLOODBAG_NAME_FORMAT('A- (1000ml)')));
BLOODBAG_ENTRY(B,1000,__EVAL(call compile BLOODBAG_NAME_FORMAT('B+ (1000ml)')));
BLOODBAG_ENTRY(BN,1000,__EVAL(call compile BLOODBAG_NAME_FORMAT('B- (1000ml)')));
BLOODBAG_ENTRY(AB,1000,__EVAL(call compile BLOODBAG_NAME_FORMAT('AB+ (1000ml)')));
BLOODBAG_ENTRY(ABN,1000,__EVAL(call compile BLOODBAG_NAME_FORMAT('AB- (1000ml)')));

class ACE_bloodIV_500: ACE_bloodIV {
    scope = 1;
};
class ACM_BloodBag_O_500: ACE_bloodIV_500 {
    scope = 2;
    author = "Blue";
    displayName = __EVAL(call compile BLOODBAG_NAME_FORMAT('O+ (500ml)'));
    descriptionShort = CSTRING(BloodBag_Desc);
};

BLOODBAG_ENTRY(ON,500,__EVAL(call compile BLOODBAG_NAME_FORMAT('O- (500ml)')));
BLOODBAG_ENTRY(A,500,__EVAL(call compile BLOODBAG_NAME_FORMAT('A+ (500ml)')));
BLOODBAG_ENTRY(AN,500,__EVAL(call compile BLOODBAG_NAME_FORMAT('A- (500ml)')));
BLOODBAG_ENTRY(B,500,__EVAL(call compile BLOODBAG_NAME_FORMAT('B+ (500ml)')));
BLOODBAG_ENTRY(BN,500,__EVAL(call compile BLOODBAG_NAME_FORMAT('B- (500ml)')));
BLOODBAG_ENTRY(AB,500,__EVAL(call compile BLOODBAG_NAME_FORMAT('AB+ (500ml)')));
BLOODBAG_ENTRY(ABN,500,__EVAL(call compile BLOODBAG_NAME_FORMAT('AB- (500ml)')));

class ACE_bloodIV_250: ACE_bloodIV {
    scope = 1;
};
class ACM_BloodBag_O_250: ACE_bloodIV_250 {
    scope = 2;
    author = "Blue";
    displayName = __EVAL(call compile BLOODBAG_NAME_FORMAT('O+ (250ml)'));
    descriptionShort = CSTRING(BloodBag_Desc);
};

BLOODBAG_ENTRY(ON,250,__EVAL(call compile BLOODBAG_NAME_FORMAT('O- (250ml)')));
BLOODBAG_ENTRY(A,250,__EVAL(call compile BLOODBAG_NAME_FORMAT('A+ (250ml)')));
BLOODBAG_ENTRY(AN,250,__EVAL(call compile BLOODBAG_NAME_FORMAT('A- (250ml)')));
BLOODBAG_ENTRY(B,250,__EVAL(call compile BLOODBAG_NAME_FORMAT('B+ (250ml)')));
BLOODBAG_ENTRY(BN,250,__EVAL(call compile BLOODBAG_NAME_FORMAT('B- (250ml)')));
BLOODBAG_ENTRY(AB,250,__EVAL(call compile BLOODBAG_NAME_FORMAT('AB+ (250ml)')));
BLOODBAG_ENTRY(ABN,250,__EVAL(call compile BLOODBAG_NAME_FORMAT('AB- (250ml)')));

#define FRESHBLOODBAG_NAME_FORMAT(string) QUOTE(format [ARR_2(C_LLSTRING(FreshBloodBag),string)])
#define FRESHBLOODBAG_NAME_FORMAT_S(string) QUOTE(format [ARR_2(C_LLSTRING(FreshBloodBag_Short),string)])

#define FRESHBLOODBAG_ENTRY(id,amount,name,shortname) \
    class TRIPLES(ACM_FreshBloodBag,amount,id): DOUBLES(ACM_FreshBloodBag,amount) { \
        displayName = name; \
        shortName = shortname; \
        uniqueBag = 1; \
    }

class ACM_FreshBloodBag_500: ACE_bloodIV_500 {
    scope = 1;
    author = "Blue";
    picture = QPATHTOF(ui\fieldBloodTransfusionKit_full_ca.paa);
    displayName = __EVAL(call compile FRESHBLOODBAG_NAME_FORMAT('(500ml) [0]'));
    shortName = __EVAL(call compile FRESHBLOODBAG_NAME_FORMAT_S('(500ml) [0]'));
    descriptionShort = CSTRING(BloodBag_Desc);
};

#include "CfgWeapons_Blood_500.hpp"

class ACM_FreshBloodBag_250: ACE_bloodIV_250 {
    scope = 1;
    author = "Blue";
    picture = QPATHTOF(ui\fieldBloodTransfusionKit_full_ca.paa);
    displayName = __EVAL(call compile FRESHBLOODBAG_NAME_FORMAT('(250ml) [0]'));
    shortName = __EVAL(call compile FRESHBLOODBAG_NAME_FORMAT_S('(250ml) [0]'));
    descriptionShort = CSTRING(BloodBag_Desc);
};

#include "CfgWeapons_Blood_250.hpp"