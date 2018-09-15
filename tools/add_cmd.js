// node ./tools/add_cmd

var fs = require('fs')

var cmd = process.argv[2]

if (!cmd) {
    console.log('No CMD Name set')
    process.exit(0)
}

var cmdFileName = cmd
var cmdConst = 'CMD_' + cmd.toUpperCase()

var newCommandsGd = fs
    .readFileSync('./src/commands.gd', 'utf8')
    .split('\n')
    .reduce((result, row) => {
        if (row.indexOf('%%NEXT_ID') === -1) {
            result.push(row)
            if (row.indexOf(cmdConst) !== -1) {
                console.log(cmdConst + ' already existing')
                process.exit(0)
            }
        } else {
            var nextId = Math.round(
                row
                    .split(':')[1]
                    .replace('%%', '')
                    .trim()
            )
            console.log('NEXT_ID: ', nextId)
            result.push('const ' + cmdConst + ' = ' + nextId)
            nextId += 1
            result.push('# %%NEXT_ID:' + nextId + '%%')
        }
        return result
    }, [])

var cmdFile = [
    "extends './base.gd'",
    '',
    'func _init():',
    "   name = '" + cmdFileName.toUpperCase() + "'",
    '',
    'func set_params(params):',
    '   pass',
    '',
    'func execute():',
    '   pass'
]

var cmdIndex = fs
    .readFileSync('./src/command/index.gd', 'utf8')
    .split('\n')
    .reduce((result, row) => {
        if (row.indexOf('# %%NEXT_CMD%%') === -1) {
            result.push(row)
        } else {
            result.push(row.replace('# %%NEXT_CMD%%', "preload('./" + cmdFileName + ".gd'),"))
            result.push(row)
        }
        return result
    }, [])

fs.writeFileSync('./src/command/' + cmdFileName + '.gd', cmdFile.join('\n'))
fs.writeFileSync('./src/command/index.gd', cmdIndex.join('\n'))
fs.writeFileSync('./src/commands.gd', newCommandsGd.join('\n'))

console.log('Command Added: ' + cmdConst)
