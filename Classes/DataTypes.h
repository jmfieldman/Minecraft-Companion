//
//  DataTypes.h
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum PhaseOfDay {
	TOD_PHASE_SUNRISE  = 1,
	TOD_PHASE_DAY      = 2,
	TOD_PHASE_SUNSET   = 3,
	TOD_PHASE_NIGHT    = 4,
} PhaseOfDay_t;


typedef struct CycleTimestamp {
	PhaseOfDay_t phase;
	float progress;
} CycleTimestamp_t;

