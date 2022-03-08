function quadfinT(N,i,uv)

    if (i>1 && i<mc)
        xw = tr(uv,i)
        return xw
    end

    if mc==1
      if (AB[i,1]!=-Inf)&&(AB[i,2]!=Inf)
        xw = tr(uv,i)
        return xw
      elseif AB[i,1]!=-Inf
          xw = rtr(uv,i)
          return xw
      elseif AB[i,2]!=Inf
          xw = ltr(uv,i)
          return xw
      else
          xw = str(uv,i)
          return xw
      end
    else
      if ((i==1 && AB[i,1]!=-Inf)||(i==mc && AB[i,2]!=Inf))
        xw = tr(uv,i)
        return xw
      elseif i==1
        xw = ltr(uv,i)
        return xw
      end
    end

    xw = rtr(uv,mc)
    return xw
end

function tr(t,i)
    s = Array{Float64}(undef, size(t))
    s[:,1] = ((AB[i,2]-AB[i,1])*t[:,1] .+ AB[i,2] .+ AB[i,1])./2
    s[:,2] = (AB[i,2]-AB[i,1]).*t[:,2].*wf(s[:,1],i)./2
    return s
end

function str(t,i)
    s = Array{Float64}(undef, size(t))
    s[:,1] = t[:,1]./(1-t[:,1].^2)
    s[:,2] = t[:,2].*wf(s[:,1],i).*(1+t[:,1].^2)./((1-t[:,1].^2).^2)
    return s
end

function rtr(t,i)
    s = Array{Float64}(undef, size(t))
    s[:,1] = AB[i,1] .+ (t[:,1] .+ 1)./(-t[:,1] .+ 1)
    s[:,2] = 2*t[:,2].*wf(s[:,1],i)./((1 .-t[:,1]).^2)
    return s
end

function ltr(t,i)
    s = Array{Float64}(undef, size(t))
    s[:,1] = -(-t[:,1].+1)./(t[:,1].+1) .+ AB[i,2]
    s[:,2] = 2*t[:,2].*wf(s[:,1],i)./((t[:,1] .+ 1).^2)
    return s
end

function Vk(x)
    return sqrt(1-x^2)
end

function ϵ(x)
    return x
end

# FERMIONIC
function wf(x,i)
    if i==1
        y = 0
    elseif i==2 || i==3
        if chain==1
            y = Vk.(x) .* sqrt.(1. ./(exp.(-beta .* ϵ.(x)) .+ 1))
        elseif chain==2
            y = Vk.(x) .* sqrt.(1. ./(exp.(beta .* ϵ.(x)) .+ 1))
        end
    elseif i==4
        y = 0
    end
    return y
end
