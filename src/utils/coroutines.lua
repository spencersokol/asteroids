actions = {}

function exec_actions()

    for a in all(actions) do

        if (costatus(a) == "dead") then
            del(actions, a)
        else
            assert(coresume(a))
        end
    end

end

function async(func)
    add(actions, cocreate(func))
end

function wait(frames)
    for i = 1, frames do
        yield()
    end
end