#include "\a3\ui_f\hpp\defineCommonGrids.inc"

#define IDC_SURGICAL_AIRWAY                            87000
#define IDC_SURGICAL_AIRWAY_TARGET                     87001
#define IDC_SURGICAL_AIRWAY_PALPATE                    87002
#define IDC_SURGICAL_AIRWAY_SPACE_ACTIONAREA           87003
#define IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_SHAPE       87004
#define IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_SHAPE2      87005
#define IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_UPPER       87006
#define IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_UPPERMIDDLE 87007
#define IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_LOWER       87008
#define IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRY       87009
#define IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRYAREA   87010
#define IDC_SURGICAL_AIRWAY_SPACE_INCISION             87011
#define IDC_SURGICAL_AIRWAY_SPACE_INCISION_VERTICAL    87012
#define IDC_SURGICAL_AIRWAY_SPACE_INCISION_HORIZONTAL  87013
#define IDC_SURGICAL_AIRWAY_SPACE_CRICENTRY            87014
#define IDC_SURGICAL_AIRWAY_ACTION_OPENINCISION        87015
#define IDC_SURGICAL_AIRWAY_ACTION_LIFTINCISION        87016
#define IDC_SURGICAL_AIRWAY_ACTION_REMOVEHOOK          87017
#define IDC_SURGICAL_AIRWAY_ACTION_INSERTTUBE          87018
#define IDC_SURGICAL_AIRWAY_ACTION_INFLATECUFF         87019
#define IDC_SURGICAL_AIRWAY_ACTION_REMOVESTYLET        87020
#define IDC_SURGICAL_AIRWAY_ACTION_CONNECTSTRAP        87021
#define IDC_SURGICAL_AIRWAY_ACTION_SECURESTRAP         87022
#define IDC_SURGICAL_AIRWAY_VISUAL_ACTIVEITEM          87023
#define IDC_SURGICAL_AIRWAY_VISUAL_PLACED_HOOK         87024
#define IDC_SURGICAL_AIRWAY_VISUAL_PLACED_TUBE         87025
#define IDC_SURGICAL_AIRWAY_VISUAL_INCISIONGROUP       87026
#define IDC_SURGICAL_AIRWAY_VISUAL_INCISIONBIG         87027
#define IDC_SURGICAL_AIRWAY_INVBUTTON_SCALPEL          87028
#define IDC_SURGICAL_AIRWAY_INVBUTTON_SCALPEL_IMG      87029
#define IDC_SURGICAL_AIRWAY_INVBUTTON_HOOK             87030
#define IDC_SURGICAL_AIRWAY_INVBUTTON_HOOK_IMG         87031
#define IDC_SURGICAL_AIRWAY_INVBUTTON_TUBE             87032
#define IDC_SURGICAL_AIRWAY_INVBUTTON_TUBE_IMG         87033
#define IDC_SURGICAL_AIRWAY_INVBUTTON_SYRINGE          87034
#define IDC_SURGICAL_AIRWAY_INVBUTTON_SYRINGE_IMG      87035
#define IDC_SURGICAL_AIRWAY_INVBUTTON_STRAP            87036
#define IDC_SURGICAL_AIRWAY_INVBUTTON_STRAP_IMG        87037

#define ACM_SURGICAL_AIRWAY_POS_X(N) (N * GUI_GRID_W + GUI_GRID_CENTER_X)
#define ACM_SURGICAL_AIRWAY_POS_Y(N) (N * GUI_GRID_H + GUI_GRID_CENTER_Y)
#define ACM_SURGICAL_AIRWAY_POS_W(N) (N * GUI_GRID_W)
#define ACM_SURGICAL_AIRWAY_POS_H(N) (N * GUI_GRID_H)
#define ACM_SURGICAL_AIRWAY_POS_X_CENTER(N,X) (ACM_SURGICAL_AIRWAY_POS_X(X) - (ACM_SURGICAL_AIRWAY_POS_W(N) / 2))
#define ACM_SURGICAL_AIRWAY_POS_Y_CENTER(N,Y) (ACM_SURGICAL_AIRWAY_POS_Y(Y) - (ACM_SURGICAL_AIRWAY_POS_H(N) / 2))

#define ACM_SURGICAL_AIRWAY_SPACE_INCISION_W ACM_SURGICAL_AIRWAY_POS_W(0.1)
#define ACM_SURGICAL_AIRWAY_SPACE_INCISION_H ACM_SURGICAL_AIRWAY_POS_H(0.1)

#define ACM_SURGICAL_AIRWAY_VISUAL_INCISION_W ACM_SURGICAL_AIRWAY_POS_W(6.3)

#define SURGICAL_AIRWAY_SELECTED_NONE -1
#define SURGICAL_AIRWAY_SELECTED_SCALPEL 0
#define SURGICAL_AIRWAY_SELECTED_HOOK 1
#define SURGICAL_AIRWAY_SELECTED_TUBE 2
#define SURGICAL_AIRWAY_SELECTED_SYRINGE 3
#define SURGICAL_AIRWAY_SELECTED_STRAP 4

#define SURGICAL_AIRWAY_BUTTON_SCALPEL_Y ACM_SURGICAL_AIRWAY_POS_Y(3)
#define SURGICAL_AIRWAY_BUTTON_HOOK_Y    ACM_SURGICAL_AIRWAY_POS_Y(9)
#define SURGICAL_AIRWAY_BUTTON_TUBE_Y    ACM_SURGICAL_AIRWAY_POS_Y(15)
#define SURGICAL_AIRWAY_BUTTON_SYRINGE_Y ACM_SURGICAL_AIRWAY_POS_Y(21)
#define SURGICAL_AIRWAY_BUTTON_STRAP_Y   ACM_SURGICAL_AIRWAY_POS_Y(27)