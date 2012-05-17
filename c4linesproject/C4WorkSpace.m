//
//  C4WorkSpace.m
//  mwylegly_0503_01
//
//  Created by MADT.Student on 12-05-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "C4WorkSpace.h"
#import "C4Vector.h"

@implementation C4WorkSpace{
    
    
    CGPoint pointList[300];
    CGPoint touchPoint;
    C4Shape *elPoints;
    float xPointValue, yPointValue;
    int pointOriginWidth, pointOriginHeight;
    int imageSelc;
    int imageSelcLine;
    
    
    int pointCount;
    int pointDist;
    int randomSize1;
    int randomSize2;
    int pixelValue;
    bool hideLines;
    bool randomPixSize;
    bool randomPixDistance;
    bool multiPicture;
    C4Image *testImage;
    C4Image *testImage2;
    C4Shape *lineTest;
    C4Camera *newCamera;
    
}


-(void)setup {
    
    //sets up background colour, and images, comment out the next line to change background colour to white.
    //self.canvas.backgroundColor = [UIColor colorWithRed:.95 green:.7 blue:.5 alpha:1];
    testImage2 = [C4Image imageNamed:@"test_img.jpg"];
    
    //changing these variables changes how the program renders out.
    pointCount = 35;
    pointDist = 15;
    randomSize1 = 15;
    randomSize2 = 1;
    hideLines = NO;
    randomPixSize = YES;
    randomPixDistance = FALSE;
    multiPicture = TRUE;
    
    if (pointCount < 75) {
        pointCount = pointCount;
    } else {
        pointCount = 75;
    }
    
    newCamera = [C4Camera cameraWithFrame:CGRectZero];
    [self addCamera:newCamera];
    newCamera.userInteractionEnabled = NO;
    
}

-(void)imageWasCaptured {
    C4Log(@"%4.2f", 2);
    testImage = newCamera.capturedImage;
    testImage.frame = self.canvas.frame;
    //[self.canvas addImage:testImage3];
    [self renderMethod];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touchPoint = [[touches anyObject] locationInView:self.canvas];
    [newCamera captureImage];
}

-(void)renderMethod {
    
    //determines whther 1 or 2 images are used.
    if (multiPicture == TRUE) {
    } else {
        testImage2 = testImage;
    }
    
    //gets the postion of where the screen is touched
    
    C4Log(@"%4.2f,%4.2f", touchPoint.x, touchPoint.y);
    
    C4Vector *getVecColor1 = [C4Vector vectorWithX:0 Y:0 Z:0];
    C4Vector *getVecColor2 = [C4Vector vectorWithX:0 Y:0 Z:0];
    
    for (int i = 0; i < pointCount; i++) {
        
        imageSelc = [C4Math randomInt:(2)];
        
        if (randomPixDistance == TRUE) {
            pointOriginWidth = [C4Math randomIntBetweenA:(0) 
                                                    andB:(self.canvas.frame.size.width)];
            
            pointOriginHeight = [C4Math randomIntBetweenA:(0) 
                                                     andB:(self.canvas.frame.size.height)];
        } else {
            pointOriginWidth = [C4Math randomIntBetweenA:(touchPoint.x - (20 * pointDist)) 
                                                    andB:(touchPoint.x + (20 * pointDist))];
            
            pointOriginHeight = [C4Math randomIntBetweenA:(touchPoint.y - (20 * pointDist)) 
                                                     andB:(touchPoint.y + (20 * pointDist))];
        }
        
        
        
        
        pointList[i] = CGPointMake(pointOriginWidth, pointOriginHeight); 
        //C4Log(@"%4.2f,%4.2f", pointList[i]);
        
        xPointValue = pointList[i].x;
        yPointValue = pointList[i].y;
        //C4Log(@"%4.2f,%4.2f", xPointValue, yPointValue);
        
        C4Vector *getVecColorPoint = [C4Vector vectorWithX:0 Y:0 Z:0];
        
        if (imageSelc == 1) {
            getVecColorPoint = [testImage rgbVectorAt:pointList[i]];
        } else {
            getVecColorPoint = [testImage2 rgbVectorAt:pointList[i]];
        }
        
        UIColor *pointCol;
        
        [getVecColorPoint divideScalar:255.0];
        
        if (randomPixSize == TRUE) {
            pixelValue = [C4Math randomIntBetweenA:randomSize2
                                              andB:randomSize1];
        } else {
            pixelValue = randomSize1;
        }
        
        
        pointCol = [UIColor colorWithRed:getVecColorPoint.x 
                                   green:getVecColorPoint.y 
                                    blue:getVecColorPoint.z 
                                   alpha:.65];
        
        elPoints = [C4Shape ellipse:CGRectMake(pointOriginWidth-(pixelValue/2), pointOriginHeight-(pixelValue/2), pixelValue, pixelValue)];
        
        elPoints.lineWidth = .75f;
        elPoints.fillColor = pointCol;
        elPoints.strokeColor = [UIColor clearColor];
        
        [self.canvas addShape:elPoints];
    }
    
    if (hideLines == YES) {
    } else {
        for (int index = 0; index < pointCount; index++) {
            for (int index2 = index+1; index2 < pointCount; index2 ++) {
                
                imageSelcLine = [C4Math randomInt:(4)];
                
                CGPoint linePoints[2] = {
                    CGPointMake(pointList[index].x, pointList[index].y),
                    CGPointMake(pointList[index2].x, pointList[index2].y)
                };
                
                CGFloat deltay = linePoints[0].y - linePoints[1].y;
                CGFloat deltax = linePoints[0].x - linePoints[1].x;
                CGFloat distance = sqrt(pow(deltax,2) + pow(deltay,2));
                
                C4Shape *webbing = [C4Shape line:linePoints];
                webbing.animationDuration = 0.0f;
                CGFloat alpha = 0.0f;
                
                testImage.origin = CGPointMake(384, 512);
                testImage2.center = CGPointMake(384, 512);
                
                //            UIColor *c = [testImage colorAt:linePoints[0]];
                //            C4Log(@"%@",c);
                
                if (imageSelcLine == 1) {
                    getVecColor1 = [testImage rgbVectorAt:linePoints[1]];
                    getVecColor2 = [testImage rgbVectorAt:linePoints[0]];
                } else if (imageSelcLine == 2) {
                    getVecColor1 = [testImage rgbVectorAt:linePoints[1]];
                    getVecColor2 = [testImage2 rgbVectorAt:linePoints[0]];
                } else if (imageSelcLine == 3) {
                    getVecColor1 = [testImage2 rgbVectorAt:linePoints[1]];
                    getVecColor2 = [testImage rgbVectorAt:linePoints[0]];
                } else {
                    getVecColor1 = [testImage2 rgbVectorAt:linePoints[1]];
                    getVecColor2 = [testImage2 rgbVectorAt:linePoints[0]];
                }
                
                
                [getVecColor1 add:getVecColor2];
                [getVecColor1 divideScalar:2.0];
                [getVecColor1 divideScalar:255.0];
                
                
                
                if (distance > 500) {
                    alpha = 0.0;
                    webbing.lineWidth = .5f;
                }  else if(distance > 400 && distance < 500) {
                    alpha = 0.0;
                    webbing.lineWidth = .75f;
                } else if(distance > 300 && distance < 400) {
                    alpha = 0.05;
                    webbing.lineWidth = 1.0f;
                } else if(distance > 200 && distance < 300){
                    alpha = 0.1;
                    webbing.lineWidth = 1.25f;   
                } else if(distance > 100 && distance < 200){
                    alpha = 0.2;
                    webbing.lineWidth = 1.5f;   
                } else if(distance > 50 && distance < 100){
                    alpha = 0.4;
                    webbing.lineWidth = 1.75f;
                } else if(distance > 25 && distance < 50){
                    alpha = 0.6;
                    webbing.lineWidth = 2.0f;
                } else {
                    alpha = 0.8;
                    webbing.lineWidth = 2.5f;
                }
                
                UIColor *c;
                if(getVecColor1 != nil) {
                    C4Log(@"not nil %4.2f,%4.2f,%4.2f,%4.2f", getVecColor1.x, getVecColor1.y, getVecColor1.z, alpha);
                    c = [UIColor colorWithRed:getVecColor1.x 
                                        green:getVecColor1.y 
                                         blue:getVecColor1.z 
                                        alpha:alpha];
                }
                
                webbing.strokeColor = c;
                [self.canvas addShape:webbing];
            }
        }
    }
    
}


@end
