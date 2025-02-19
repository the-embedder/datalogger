import os, machine

def updater(updates):
    for update in updates:
        source, target = update.split('>')
        source, target = source.strip(), target.strip()
        print(f'Found update: "{source}" -> "{target}"')
        try:
            os.remove(target)
        except OSError:
            pass
        try:
            os.rename(source, target)
        except OSError as e:
            print(f'Moving "{source}" to "{target}" failed:', e)

try:
    os.chdir('/uploads')
    with open('update.txt', 'rt') as updates:
        print('Updating files...')
        updater(updates)
    try:
        os.remove('update.txt')
    except OSError as e:
        print('Removing "update.txt" failed:', e)
    print('...done.')
    machine.soft_reset()

except OSError:
    print('No updates found.')
