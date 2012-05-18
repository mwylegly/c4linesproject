//
//  C4WorkSpace.m
//  mwylegly_0503_01
//
//  Created by MADT.Student on 12-05-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "C4WorkSpace.h"
#import "C4Vector.h"

@interface C4WorkSpace ()
-(CGFloat)lineWidthFromDistance:(CGFloat)distance;
-(CGFloat)lineAlphaFromDistance:(CGFloat)distance;
-(void)renderWebbing;
-(void)renderCircles;
//hi mike

@property C4Image *image1, *image2;
@end

@implementation C4WorkSpace{    
    CGPoint pointList[300];
    CGPoint touchPoint;
    
    int pointCount;
    int pointDist;
    int randomSize1;
    int randomSize2;
    int pixelValue;
    bool randomPixSize;
    bool randomPixDistance;
    bool multiPicture;
    C4Shape *lineTest;
    C4Camera *newCamera;
    
    BOOL shouldRenderWebbing;
}

@synthesize image1, image2;

-(void)setup {
    
    //sets up background colour, and images, comment out the next line to change background colour to white.
    //self.canvas.backgroundColor = [UIColor colorWithRed:.95 green:.7 blue:.5 alpha:1];
    
    //changing these variables changes how the program renders out.
    pointCount = 35;
    pointDist = 15;
    randomSize1 = 15;
    randomSize2 = 1;
    randomPixSize = YES;
    randomPixDistance = YES;
    multiPicture = YES;
    
    shouldRenderWebbing = YES;
    
    if(pointCount > 75) pointCount = 75;
    
    newCamera = [C4Camera cameraWithFrame:CGRectZero];
    [self addCamera:newCamera];
}

-(void)imageWasCaptured {
    self.image1 = newCamera.capturedImage;
    self.image1.frame = self.canvas.frame;
    
    if (multiPicture == NO) {
        self.image2 = self.image1;    
    } else {
        self.image2 = [C4Image imageNamed:@"test_img.jpg"];
    }
    [self renderCircles];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touchPoint = [[touches anyObject] locationInView:self.canvas];
    [newCamera captureImage];
}

-(void)renderCircles {
    for (int i = 0; i < pointCount; i++) {
        
        pointList[i] = CGPointZero;
        
        C4Vector *getVecColorPoint;
        
        if(randomPixDistance) {
            pointList[i].x = [C4Math randomInt:(self.canvas.frame.size.width)];
            pointList[i].y = [C4Math randomInt:(self.canvas.frame.size.height)];
            getVecColorPoint = [self.image1 rgbVectorAt:pointList[i]];
        } else {
            pointList[i].x = [C4Math randomIntBetweenA:(touchPoint.x - (20 * pointDist))
                                                  andB:(touchPoint.x + (20 * pointDist))];
            pointList[i].y = [C4Math randomIntBetweenA:(touchPoint.y - (20 * pointDist)) 
                                                  andB:(touchPoint.y + (20 * pointDist))];
            getVecColorPoint = [self.image2 rgbVectorAt:pointList[i]];
        }
        
        [getVecColorPoint divideScalar:255.0];
        
        if (randomPixSize == YES) {
            pixelValue = [C4Math randomIntBetweenA:randomSize1
                                              andB:randomSize2];
        } else {
            pixelValue = randomSize1;
        }
        
        UIColor *currentEllipseColor = [UIColor colorWithRed:getVecColorPoint.x 
                                                       green:getVecColorPoint.y 
                                                        blue:getVecColorPoint.z 
                                                       alpha:.65];
        CGFloat x, y, w, h;
        x = pointList[i].x-(pixelValue/2);
        y = pointList[i].y-(pixelValue/2);
        w = pixelValue;
        h = pixelValue;
        
        C4Shape *currentEllipse = [C4Shape ellipse:CGRectMake(x,y,w,h)];
        currentEllipse.lineWidth = .75f;
        currentEllipse.fillColor = currentEllipseColor;
        currentEllipse.strokeColor = [UIColor clearColor];
        
        [self.canvas addShape:currentEllipse];
    }
    
    if (shouldRenderWebbing == YES) {
        [self renderWebbing];
    }
}

-(void)renderWebbing {
    for (int index = 0; index < pointCount; index++) {
        for (int index2 = index+1; index2 < pointCount; index2 ++) {
            
            C4Shape *webbing = [C4Shape new];
            webbing.animationDuration = 0.0f;
            
            CGPoint linePoints[2] = {
                CGPointMake(pointList[index].x, pointList[index].y),
                CGPointMake(pointList[index2].x, pointList[index2].y)
            };
            
            [webbing line:linePoints];
            
            CGFloat distance = [C4Vector distanceBetweenA:linePoints[0] andB:linePoints[1]];
            CGFloat webbingLineWidth = [self lineWidthFromDistance:distance];
            webbing.lineWidth = webbingLineWidth;
            
            CGFloat webbingAlpha = [self lineAlphaFromDistance:distance];
            
            if(webbingLineWidth > 0 && webbingAlpha > 0) {
                C4Vector *getVecColor1 = [C4Vector vectorWithX:0 Y:0 Z:0];
                C4Vector *getVecColor2 = [C4Vector vectorWithX:0 Y:0 Z:0];
                
                //4 cases to pull point colors from, random
                switch ([C4Math randomInt:(4)]) {
                    case 0:
                        getVecColor1 = [self.image1 rgbVectorAt:linePoints[1]];
                        getVecColor2 = [self.image1 rgbVectorAt:linePoints[0]];
                        break;
                    case 1:
                        getVecColor1 = [self.image1 rgbVectorAt:linePoints[1]];
                        getVecColor2 = [self.image2 rgbVectorAt:linePoints[0]];
                        break;
                    case 2:
                        getVecColor1 = [self.image2 rgbVectorAt:linePoints[1]];
                        getVecColor2 = [self.image1 rgbVectorAt:linePoints[0]];
                        break;
                    case 3:
                        getVecColor1 = [self.image2 rgbVectorAt:linePoints[1]];
                        getVecColor2 = [self.image2 rgbVectorAt:linePoints[0]];
                        break;
                    default:
                        break;
                }
                
                [getVecColor1 add:getVecColor2];
                [getVecColor1 divideScalar:2.0];
                [getVecColor1 divideScalar:255.0];
                
                UIColor *c;
                if(getVecColor1 != nil) {
                    c = [UIColor colorWithRed:getVecColor1.x 
                                        green:getVecColor1.y 
                                         blue:getVecColor1.z 
                                        alpha:webbingAlpha];
                }
                
                webbing.strokeColor = c;
                [self.canvas addShape:webbing];
            } else {
                webbing = nil;
            }
        }
    }
}

-(CGFloat)lineWidthFromDistance:(CGFloat)distance {
    if (distance > 500) {
        return 0.0f;
    }  else if(distance > 400 && distance < 500) {
        return .75f;
    } else if(distance > 300 && distance < 400) {
        return 1.0f;
    } else if(distance > 200 && distance < 300){
        return 1.25f;   
    } else if(distance > 100 && distance < 200){
        return 1.5f;   
    } else if(distance > 50 && distance < 100){
        return 1.75f;
    } else if(distance > 25 && distance < 50){
        return 2.0f;
    } 
    return 2.5f;
}

-(CGFloat)lineAlphaFromDistance:(CGFloat)distance {
    if (distance > 500) {
        return 0.0f;
    }  else if(distance > 400 && distance < 500) {
        return 0.0f;
    } else if(distance > 300 && distance < 400) {
        return 0.05f;
    } else if(distance > 200 && distance < 300){
        return 0.1f;
    } else if(distance > 100 && distance < 200){
        return 0.2f;
    } else if(distance > 50 && distance < 100){
        return 0.4f;
    } else if(distance > 25 && distance < 50){
        return 0.6f;
    }
    return 0.8;
}

@end
