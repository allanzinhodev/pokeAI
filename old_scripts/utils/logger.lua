local logger = {}

function logger.info(msg)
    print("[INFO] " .. msg)
end

function logger.error(msg)
    print("[ERROR] " .. msg)
end

return logger
