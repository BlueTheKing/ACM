#include "\a3\ui_f\hpp\defineCommonGrids.inc"

#define ACM_GUI_SyringeDraw_SIZEM 1.25

#define ACM_Syringe_Draw_GUI_GRID_W (safezoneW * 0.55)
#define ACM_Syringe_Draw_GUI_GRID_H (ACM_Syringe_Draw_GUI_GRID_W * 4/3)
#define ACM_Syringe_Draw_GUI_GRID_X (safezoneX + (safezoneW - ACM_Syringe_Draw_GUI_GRID_W) / 2)
#define ACM_Syringe_Draw_GUI_GRID_Y (safezoneY + (safezoneH - ACM_Syringe_Draw_GUI_GRID_H) / 2)

#define ACM_SyringeDraw_pxToScreen_X(X) (X / 1024 * ACM_Syringe_Draw_GUI_GRID_W + ACM_Syringe_Draw_GUI_GRID_X)
#define ACM_SyringeDraw_pxToScreen_Y(X) (X / 1024 * ACM_Syringe_Draw_GUI_GRID_H + ACM_Syringe_Draw_GUI_GRID_Y)
#define ACM_SyringeDraw_pxToScreen_W(X) (X / 1024 * ACM_Syringe_Draw_GUI_GRID_W)
#define ACM_SyringeDraw_pxToScreen_H(X) (X / 1024 * ACM_Syringe_Draw_GUI_GRID_H)

#define IDC_SYRINGEDRAW 84000
#define IDC_SYRINGEDRAW_TEXT 84001
#define IDC_SYRINGEDRAW_BOTTOMTEXT 84002
#define IDC_SYRINGEDRAW_BUTTON_DRAW 84003
#define IDC_SYRINGEDRAW_BUTTON_PUSH 84004
#define IDC_SYRINGEDRAW_BUTTON_INJECT 84005
#define IDC_SYRINGEDRAW_MEDLIST 84006
#define IDC_SYRINGEDRAW_MEDLIST_SELECTION_BUTTON 84007
#define IDC_SYRINGEDRAW_MEDLIST_SELECTION_TEXT 84008
#define IDC_SYRINGEDRAW_PLUNGER 84009
#define IDC_SYRINGEDRAW_SYRINGE_10_GROUP 84010
#define IDC_SYRINGEDRAW_SYRINGE_10_PLUNGER 84011
#define IDC_SYRINGEDRAW_SYRINGE_5_GROUP 84012
#define IDC_SYRINGEDRAW_SYRINGE_5_PLUNGER 84013
#define IDC_SYRINGEDRAW_SYRINGE_3_GROUP 84014
#define IDC_SYRINGEDRAW_SYRINGE_3_PLUNGER 84015
#define IDC_SYRINGEDRAW_SYRINGE_1_GROUP 84016
#define IDC_SYRINGEDRAW_SYRINGE_1_PLUNGER 84017

#define SYRINGEDRAW_MOUSE_X (safezoneX + (safezoneW / 2))

#define SYRINGEDRAW_LIMIT_10_TOP         ACM_SyringeDraw_pxToScreen_Y(721)
#define SYRINGEDRAW_LIMIT_10_TOP_MOUSE   ACM_SyringeDraw_pxToScreen_Y(723)
#define SYRINGEDRAW_LIMIT_10_BOTTOM      ACM_SyringeDraw_pxToScreen_Y(984)
#define SYRINGEDRAW_LIMIT_5_TOP          ACM_SyringeDraw_pxToScreen_Y(707)
#define SYRINGEDRAW_LIMIT_5_TOP_MOUSE    ACM_SyringeDraw_pxToScreen_Y(709)
#define SYRINGEDRAW_LIMIT_5_BOTTOM       ACM_SyringeDraw_pxToScreen_Y(962)
#define SYRINGEDRAW_LIMIT_3_TOP          ACM_SyringeDraw_pxToScreen_Y(706)
#define SYRINGEDRAW_LIMIT_3_TOP_MOUSE    ACM_SyringeDraw_pxToScreen_Y(708)
#define SYRINGEDRAW_LIMIT_3_BOTTOM       ACM_SyringeDraw_pxToScreen_Y(952)
#define SYRINGEDRAW_LIMIT_1_TOP          ACM_SyringeDraw_pxToScreen_Y(706)
#define SYRINGEDRAW_LIMIT_1_TOP_MOUSE    ACM_SyringeDraw_pxToScreen_Y(708)
#define SYRINGEDRAW_LIMIT_1_BOTTOM       ACM_SyringeDraw_pxToScreen_Y(961)