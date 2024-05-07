#define ST_LEFT					0x00
#define ST_RIGHT				0x01
#define ST_CENTER				0x02
#define ST_DOWN					0x04
#define ST_UP					0x08
#define ST_VCENTER				0x0C
#define ST_SINGLE				0x00
#define ST_MULTI				0x10
#define ST_TITLE_BAR			0x20
#define ST_PICTURE				0x30
#define ST_FRAME				0x40
#define ST_BACKGROUND			0x50
#define ST_GROUP_BOX			0x60
#define ST_GROUP_BOX2			0x70
#define ST_HUD_BACKGROUND		0x80
#define ST_TILE_PICTURE			0x90
#define ST_WITH_RECT			0xA0
#define ST_LINE					0xB0
#define ST_UPPERCASE			0xC0
#define ST_LOWERCASE			0xD0
#define ST_ADDITIONAL_INFO		0x0F00
#define ST_SHADOW				0x0100
#define ST_NO_RECT				0x0200
#define ST_KEEP_ASPECT_RATIO	0x0800
#define ST_TITLE				ST_TITLE_BAR + ST_CENTER
#define SL_VERT					0
#define SL_HORZ					0x400
#define SL_TEXTURES				0x10
#define ST_VERTICAL				0x01
#define ST_HORIZONTAL			0
#define LB_TEXTURES				0x10
#define LB_MULTI				0x20
#define TR_SHOWROOT				1
#define TR_AUTOCOLLAPSE			2

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