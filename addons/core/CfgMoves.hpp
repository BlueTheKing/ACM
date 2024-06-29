class CfgMovesBasic {
    class Default;
};

class CfgMovesMaleSdr: CfgMovesBasic {
    class States {
        class ACM_GenericContinuous: Default {
            file = "\a3\anims_f\data\anim\sdr\idl\knl\stp\non\non\AidlPknlMstpSnonWnonDnon_G02.rtm";
            speed = -100;
            looped = 1;
            disableWeapons = 1;
            disableWeaponsLong = 1;
            showWeaponAim = 0;
            canPullTrigger = 0;
            duty = 0.2;
            limitGunMovement = 0;
            aiming = "empty";
            aimingBody = "empty";
            //ConnectAs = "";
            ConnectTo[] = {};
            forceAim = 1;
            //InterpolateFrom[] = {};
            //InterpolateWith[] = {};
            InterpolateTo[] = {
                "Unconscious",
                0.02
            };
        };
        class ainjppnemstpsnonwrfldnon;
        class ACM_LyingState: ainjppnemstpsnonwrfldnon {
            file = QPATHTO_T(anim\ACM_LyingState.rtm);
            speed = -100;
            looped = 1;
            disableWeapons = 1;
            disableWeaponsLong = 1;
            showWeaponAim = 0;
            canPullTrigger = 0;
            duty = 0.2;
            limitGunMovement = 0;
            aiming = "aimingNo";
            aimingBody = "aimingUpNo";
            head = "headNo";
            ConnectTo[] = {};
            forceAim = 1;
            InterpolateTo[] = {};
        };
    };
};