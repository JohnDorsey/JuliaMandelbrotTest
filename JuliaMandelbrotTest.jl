


cameraCoords = (-1.0,0.0)
travel = (4.0,4.0)
resolution = (128,64)
printChars = string(" -~=+%&\$", String([Char(22)]))
maxIters = 1024


function escaped(z,escapeRadius)
  return sum(item^2 for item in z) >= escapeRadius^2
end

function solve(c,escapeRadius=4.0)
  z = (0.0, 0.0)
  for iter=1:maxIters
    z = ((z[1]^2 - z[2]^2)+c[1], 2*z[1]*z[2]+c[2])
    if escaped(z,escapeRadius) return iter end
  end
  return maxIters+1
end


function toScreenChar(num,rangeStart,rangeEnd)
  #index = (rangeStart<=num<=rangeEnd) ?
  #  Int(round(
  #    (length(printChars)-1)*(((num-rangeStart)/(rangeEnd-rangeStart))^0.65)
  #  )) : 0
  #index += 1
  index = (num <= rangeEnd) ? Int(round((sin(log(num-rangeStart)^2)*0.5+0.5)*(length(printChars)-1)+1)) : 1
  return printChars[index]
end


function screenToComplex(xy)
  return ((xy[1]/resolution[1]-0.5)*travel[1]+cameraCoords[1],(xy[2]/resolution[2]-0.5)*travel[2]+cameraCoords[2])
end


function complexToScreen(c)
  return (Int(((c[1]-cameraCoords[1])/travel[1]+0.5)*resolution[1]),Int(((c[2]-cameraCoords[2])/travel[2]+0.5)*resolution[2]))
end


function screen(autoMaxIters)
  minRecordedEscapeIters = maxIters
  maxRecordedEscapeIters = 0
  result = ['\n']
  for y=1:resolution[2]
    for x=1:resolution[1]
      c = screenToComplex((x,y))
      escapeIters = solve(c)
      if escapeIters != maxIters+1
        maxRecordedEscapeIters = maximum([maxRecordedEscapeIters,escapeIters])
        minRecordedEscapeIters = minimum([minRecordedEscapeIters,escapeIters])
      end
      push!(result,toScreenChar(escapeIters,1,maxIters))
    end
    push!(result,'\n')
  end
  if autoMaxIters > 0
    global maxIters = Int(round(maximum([maxIters,minRecordedEscapeIters * autoMaxIters])))
  end
  return String(result)
end


function demo()
  #run this.
  global cameraCoords = (-0.1628021,1.035177)
  global travel = (4.0,4.0)
  while travel[1] > 9.0*10^-9
    global travel = (travel[1]*0.9,travel[2]*0.9)
    print(screen(4.0))
  end
end


print(screen(0))


