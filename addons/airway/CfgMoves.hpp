class CfgMovesBasic {
    class Default;
};

class CfgMovesMaleSdr: CfgMovesBasic {
    class States {
        class DeadState;
        class ACM_RecoveryPosition: DeadState {
            speed = 100;
            file = QPATHTO_T(anim\ACM_RecoveryPosition.rtm);
        };
    };
};