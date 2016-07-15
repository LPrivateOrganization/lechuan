//
//  CmdConstant.h
//  FFLtd
//
//  Created by Kami Mahou on 11/25/11.
//  Copyright (c) 2011 FFLtd. All rights reserved.
//


#define HTTP_TIMEOUT    30

typedef enum CmdCode
{
    CC_Interface_cityList   = 0x0001,
    CC_Interface_bannerList,
    CC_Interface_productList,
    CC_Interface_login,
    CC_Interface_regist,
    CC_Interface_thirdLogin,
    CC_Interface_usableTicket,
    CC_Interface_unUsableTicket,
    CC_Interface_unUsableTicket1,
    CC_Interface_deletaTicket,
    CC_Intrrface_fetchTicket,
    CC_Interface_content,
    CC_Intrrface_produceTicket,
    CC_Intrrface_changePassword,
    CC_Intrrface_updateUserInfo,
    CC_Intrrface_achieveInfo,
    CC_Intrrface_floatWindow,
    CC_Intrrface_getShareMessage,
    CC_Intrrface_buyTicket,
    CC_Intrrface_knockTicket,
    CC_Interface_getMyTest,
    CC_Interface_getBannerTest,
    CC_Intrrface_whriteInfo,
    CC_Interface_mapProductInfo,
    CC_Interface_uploadList,
    
    
} E_CMDCODE;