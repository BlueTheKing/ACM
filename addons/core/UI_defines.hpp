#include "\a3\ui_f\hpp\defineResincl.inc"

// UI stuff

#define ACM_GUI_GRID_W (safezoneW * 0.55)
#define ACM_GUI_GRID_H (ACM_GUI_GRID_W * 4/3)
#define ACM_GUI_GRID_X (safezoneX + (safezoneW - ACM_GUI_GRID_W) / 2)
#define ACM_GUI_GRID_Y (safezoneY + (safezoneH - ACM_GUI_GRID_H) / 2)

#define ACM_pxToScreen_X(X) (X / 2048 * ACM_GUI_GRID_W + ACM_GUI_GRID_X)
#define ACM_pxToScreen_Y(X) (X / 2048 * ACM_GUI_GRID_H + ACM_GUI_GRID_Y)
#define ACM_pxToScreen_W(X) (X / 2048 * ACM_GUI_GRID_W)
#define ACM_pxToScreen_H(X) (X / 2048 * ACM_GUI_GRID_H)

#define ACM_GRID_H ((((safezoneW / safezoneH) min 1.2) / 1.2) / 22)